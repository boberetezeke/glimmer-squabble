require 'forwardable'

class GamePresenter
  extend Forwardable

  def_delegator :@game, :current_player
  def_delegator :@game, :players
  def_delegator :@game, :pass

  attr_accessor :invalid_reason_text
  attr_reader :tray_presenter, :board_presenter, :player_presenters, :action_presenter, :bag_presenter
  attr_reader :placed_letters, :play_history

  def initialize(game)
    @game = game
    @tray_presenter = TrayPresenter.new(game.tray)
    @board_presenter = BoardPresenter.new(game.board)
    @player_presenters = @game.players.map{ |player| PlayerPresenter.new(player) }
    @action_presenter = ActionPresenter.new
    @bag_presenter = BagPresenter.new(game.bag)
    @placed_letters = []
    @play_history = []
    @invalid_reason_text = ''

    setup_on_selects
    @board_presenter.set_styles
  end

  def setup_on_selects
    @tray_presenter.on_select_square do |position|
      tray_square_selected(position)
    end
    @board_presenter.on_select_square do |position|
      puts "setup_on_selects: #{position}"
      board_square_selected(position)
    end
    @action_presenter.on_play_pressed do
      play_pressed
    end
    @action_presenter.on_pass_pressed do
      pass_pressed
    end
  end

  def board_square_selected(board_position)
    puts "game_presenter#board_square_selected(#{board_position})"
    square_presenter = board_presenter.square_presenters_for(board_position)
    if tray_presenter.selected_square
      bs_selected_with_ts_selected(board_position, square_presenter)
    elsif board_presenter.selected_square
      old_position = board_presenter.selected_position
      if old_position == board_position
        bs_selected_with_bs_selected
      else
        bs_selected_with_everything_unselected(board_position, square_presenter, old_position)
      end
    else
      board_presenter.select_square(board_position)
    end
    update_invalid_reason_text
  end

  def update_invalid_reason_text
    invalid_reason = play_invalid_reason
    self.invalid_reason_text = invalid_reason.nil? ? '' : invalid_reason.to_s
  end

  def bs_selected_with_ts_selected(board_position, board_square_presenter)
    tray_letter = tray_presenter.selected_square.letter
    return unless tray_letter

    if board_square_presenter.empty?
      clear_tray_letter
    elsif board_square_presenter.replaceable?
      move_board_letter_to_tray(board_position, board_square_presenter)
    end
    place_letter_on_board(board_position, tray_letter)

    unselect_tray_square
    unselect_board_square
  end

  def bs_selected_with_bs_selected
    unselect_board_square
  end

  def bs_selected_with_everything_unselected(board_position, board_square_presenter, old_board_position)
    if board_presenter.selected_square.has_unplayed_letter?
      old_board_square_presenter = board_presenter.square_presenters_for(old_board_position)
      old_board_letter = old_board_square_presenter.letter
      board_letter = board_presenter.square_presenters_for(board_position).letter
      if board_square_presenter.has_unplayed_letter?
        swap_board_letters(board_position, old_board_position, board_letter, old_board_letter)
      else
        move_board_letter(board_position, old_board_position, old_board_letter)
      end
      board_presenter.select_square(nil)
    else
      board_presenter.select_square(board_position)
    end
  end

  def tray_square_selected(tray_position)
    puts "game_presenter#tray_square_selected(#{tray_position})"
    if board_presenter.selected_square
      board_letter = board_presenter.selected_square.letter
      return unless board_letter

      board_presenter.place_letter(board_presenter.selected_position, nil)
      tray_presenter.place_letter(tray_position, board_letter)
      unselect_board_square
    else
      tray_presenter.select_square(tray_position)
    end
  end

  def play_invalid_reason
    return :not_covering_start_square unless start_square_covered?
    return :not_adjacent_to_played_letter unless adjacent_to_any_played_letter?(placed_letters)
    return :placed_letters_not_in_a_line unless placed_letters_all_in_a_line?(placed_letters)
    return :placed_letters_not_connected unless placed_letters_all_connected?(placed_letters)
    return nil
  end

  def placed_letters_all_connected?(placed_letters)
    position_index = placed_letters_all_in_a_row?(placed_letters) ? 0 : 1
    other_position_index = 1 - position_index
    sorted_letters = placed_letters.sort_by { |placed_letter| placed_letter.position[position_index] }
    start_position = sorted_letters.first.position
    position_range = (sorted_letters.first.position[other_position_index])..(sorted_letters.last.position[other_position_index])
    if position_index == 0
      positions = position_range.map{|col| [start_position[0], col] }
    else
      positions = position_range.map{|row| [row, start_position[1]] }
    end
    positions.all? { |position| @board_presenter.square_presenters_for(position).raw_letter }
  end

  def placed_letters_all_in_a_line?(placed_letters)
    placed_letters_in_a_line?(placed_letters)
  end

  def placed_letters_in_a_line?(placed_letters)
    placed_letters_all_in_a_row?(placed_letters) || placed_letters_all_in_a_col?(placed_letters)
  end

  def placed_letters_all_in_a_row?(placed_letters)
    row = placed_letters[0].position[0]
    placed_letters.all? { |placed_letter| placed_letter.position[0] == row }
  end

  def placed_letters_all_in_a_col?(placed_letters)
    col = placed_letters[0].position[1]
    placed_letters.all? { |placed_letter| placed_letter.position[1] == col }
  end

  def adjacent_to_any_played_letter?(placed_letters)
    placed_letters.any? do |placed_letter|
      adjacent_to_played_letter?(placed_letter) || on_start_square?(placed_letter)
    end
  end

  def on_start_square?(placed_letter)
    board_presenter.start_square_presenter.position == placed_letter.position
  end

  def adjacent_to_played_letter?(placed_letter)
    placed_letter.adjacent_positions(@board_presenter.size).any? do |adjacent_position|
      @board_presenter.square_presenters_for(adjacent_position).is_played
    end
  end

  def start_square_covered?
    !(board_presenter.start_square_presenter&.raw_letter.nil?)
  end

  def play_pressed(return_before: :nothing)
    puts "game_presenter#play_pressed #{@placed_letters}"
    return :no_letters_placed unless @placed_letters.any?

    invalid_reason = play_invalid_reason
    return invalid_reason unless invalid_reason.nil?

    drawn_letters = bag_presenter.draw(@placed_letters.size)

    score = current_player_presenter.score + placed_letters_total
    @placed_letters.each do |placed_letter|
      puts "placing #{placed_letter}"
      board_presenter.square_presenters_for(placed_letter.position).is_played = true
    end

    current_player_presenter.score = score
    @play_history << PlayedWord.new(current_player, @placed_letters)
    @placed_letters = []

    drawn_letter_index = 0
    tray_presenter.square_presenters.each_with_index do |square_presenter, index|
      unless square_presenter.raw_letter
        tray_presenter.place_letter(index, drawn_letters[drawn_letter_index])
        drawn_letter_index += 1
      end
    end

    return nil if return_before == :go_to_next_player

    go_to_next_player(move_to_next_player: return_before != :place_next_player_letters)

    nil
  end

  def pass_pressed
    puts "game_presenter#pass_pressed #{@placed_letters}"

    @placed_letters.each do |placed_letter|
      board_presenter.square_presenters_for(placed_letter.position).letter = nil
      # suggested by co-pilot
      tray_presenter.place_letter(tray_presenter.first_empty_position, placed_letter.letter)
    end
    @placed_letters = []

    go_to_next_player
  end

  def current_player_presenter
    @player_presenters[@game.current_player_index]
  end

  private

  def placed_letters_total
    word_modifiers(@placed_letters).inject(placed_letters_subtotal(@placed_letters)) do |product, modifier|
      modifier.modify_score(product)
    end
  end

  def placed_letters_subtotal(placed_letters)
    placed_letters.sum do |placed_letter|
      square_presenter = board_presenter.square_presenters_for(placed_letter.position)
      modifier = square_presenter.modifier
      score = square_presenter.value
      score = modifier.modify_score(score) if modifier&.for_letter?
      score
    end
  end

  def word_modifiers(placed_letters)
    placed_letters.filter_map do |placed_letter|
      square_presenter = board_presenter.square_presenters_for(placed_letter.position)
      square_presenter.modifier && square_presenter.modifier.for_word? ? square_presenter.modifier : nil
    end
  end

  def go_to_next_player(move_to_next_player: true)
    @tray_presenter.remove_player_letters(current_player)
    return unless move_to_next_player

    @game.next_player
    @tray_presenter.add_player_letters(current_player)
  end

  def unselect_board_square
    board_presenter.select_square(nil)
  end

  def unselect_tray_square
    tray_presenter.select_square(nil)
  end

  def clear_tray_letter
    tray_presenter.place_letter(tray_presenter.selected_position, nil)
  end

  def move_board_letter_to_tray(board_position, square_presenter)
    tray_presenter.place_letter(tray_presenter.selected_position, square_presenter.letter)
    @placed_letters = @placed_letters.reject { |placed_letter| placed_letter.position == board_position }
  end

  def place_letter_on_board(board_position, letter)
    board_presenter.place_letter(board_position, letter)
    @placed_letters << PlacedLetter.new(board_position, letter)
  end

  def swap_board_letters(board_position, old_position, letter, old_letter)
    @placed_letters = @placed_letters.reject { |placed_letter| placed_letter.position == old_position || placed_letter.position == board_position }
    @placed_letters << PlacedLetter.new(old_position, letter)
    @placed_letters << PlacedLetter.new(board_position, old_letter)
    board_presenter.place_letter(old_position, letter)
    board_presenter.place_letter(board_position, old_letter)
  end

  def move_board_letter(board_position, old_position, old_letter)
    @placed_letters = @placed_letters.reject { |placed_letter| placed_letter.position == old_position }
    @placed_letters << PlacedLetter.new(board_position, old_letter)
    board_presenter.place_letter(old_position, nil)
    board_presenter.place_letter(board_position, old_letter)
  end
end