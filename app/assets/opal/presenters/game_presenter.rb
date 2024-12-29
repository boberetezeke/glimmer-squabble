require 'forwardable'

class GamePresenter
  extend Forwardable

  def_delegator :@game, :current_player
  def_delegator :@game, :players
  def_delegator :@game, :pass

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

    setup_on_selects
  end

  def setup_on_selects
    @tray_presenter.on_select_square do |position|
      tray_square_selected(position)
    end
    @board_presenter.on_select_square do |position|
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
      letter = tray_presenter.selected_square.letter
      return unless letter

      if square_presenter.empty?
        tray_presenter.place_letter(tray_presenter.selected_position, nil)
      elsif square_presenter.replaceable?
        tray_presenter.place_letter(tray_presenter.selected_position, square_presenter.letter)
        @placed_letters = @placed_letters.reject { |placed_letter| placed_letter.position == board_position }
      end
      board_presenter.place_letter(board_position, letter)
      @placed_letters << PlacedLetter.new(board_position, letter)

      tray_presenter.select_square(nil)
      board_presenter.select_square(nil)
    elsif board_presenter.selected_square&.has_unplayed_letter?
      old_position = board_presenter.selected_position
      square_presenter = board_presenter.square_presenters_for(old_position)
      letter = square_presenter.letter
      @placed_letters = @placed_letters.reject { |placed_letter| placed_letter.position == old_position }
      @placed_letters << PlacedLetter.new(board_position, letter)
      board_presenter.place_letter(old_position, nil)
      board_presenter.place_letter(board_position, letter)
      board_presenter.select_square(nil)
    else
      board_presenter.select_square(board_position)
    end
  end

  def tray_square_selected(tray_position)
    puts "game_presenter#tray_square_selected(#{tray_position})"
    if board_presenter.selected_square
      letter = board_presenter.selected_square.letter
      return unless letter

      board_presenter.place_letter(board_presenter.selected_position, nil)
      tray_presenter.place_letter(tray_position, letter)
      board_presenter.select_square(nil)
    else
      tray_presenter.select_square(tray_position)
    end
  end

  def play_pressed(return_before: :nothing)
    puts "game_presenter#play_pressed #{@placed_letters}"
    return unless @placed_letters.any?

    drawn_letters = bag_presenter.draw(@placed_letters.size)

    score = current_player_presenter.score
    @placed_letters.each do |placed_letter|
      puts "placing #{placed_letter}"
      board_presenter.square_presenters_for(placed_letter.position).is_played = true
      score += 1
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

    return if return_before == :go_to_next_player

    go_to_next_player(move_to_next_player: return_before != :place_next_player_letters)
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

  def go_to_next_player(move_to_next_player: true)
    @tray_presenter.remove_player_letters(current_player)
    return unless move_to_next_player

    @game.next_player
    @tray_presenter.add_player_letters(current_player)
  end
end