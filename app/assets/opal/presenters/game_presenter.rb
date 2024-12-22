require 'forwardable'

class GamePresenter
  extend Forwardable

  def_delegator :@game, :current_player
  def_delegator :@game, :players
  def_delegator :@game, :pass

  attr_reader :tray_presenter, :board_presenter, :player_presenter
  attr_reader :placed_letters, :play_history

  def initialize(game)
    @game = game
    @tray_presenter = TrayPresenter.new(game.tray)
    @board_presenter = BoardPresenter.new(game.board)
    @player_presenter = PlayerPresenter.new(game.current_player)
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
    @player_presenter.on_play_pressed do
      play_pressed
    end
    @player_presenter.on_pass_pressed do
      pass_pressed
    end
  end

  def board_square_selected(board_position)
    puts "game_presenter#board_square_selected(#{board_position})"
    if tray_presenter.selected_square
      letter = tray_presenter.selected_square.letter
      return unless letter

      tray_presenter.place_letter(tray_presenter.selected_position, nil)
      board_presenter.place_letter(board_position, letter)
      @placed_letters << PlacedLetter.new(board_position, letter)
      tray_presenter.select_square(nil)
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

  def play_pressed
    puts "game_presenter#play_pressed #{@placed_letters}"
    return unless @placed_letters.any?

    @placed_letters.each do |placed_letter|
      puts "placing #{placed_letter}"
      board_presenter.square_presenters_for(placed_letter.position).is_played = true
    end
    @play_history << PlayedWord.new(current_player, @placed_letters)
    @placed_letters = []
  end

  def pass_pressed
    puts "game_presenter#pass_pressed #{@placed_letters}"
    return unless @placed_letters.any?

    @placed_letters.each do |placed_letter|
      board_presenter.square_presenters_for(placed_letter.position).letter = nil
      # suggested by co-pilot
      tray_presenter.place_letter(tray_presenter.first_empty_position, placed_letter.letter)
    end
    @placed_letters = []
  end
end