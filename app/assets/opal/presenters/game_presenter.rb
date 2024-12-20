require 'forwardable'

class GamePresenter
  extend Forwardable

  def_delegator :@game, :current_player
  def_delegator :@game, :players
  def_delegator :@game, :pass

  attr_reader :tray_presenter, :board_presenter, :player_presenter

  def initialize(game)
    @game = game
    @tray_presenter = TrayPresenter.new(game.tray)
    @board_presenter = BoardPresenter.new(game.board)
    @player_presenter = PlayerPresenter.new(game.current_player)

    setup_on_selects
  end

  def setup_on_selects
    @tray_presenter.on_select_square do |position|
      tray_square_selected(position)
    end
    @board_presenter.on_select_square do |position|
      board_square_selected(position)
    end
  end

  def board_square_selected(board_position)
    puts "game_presenter#board_square_selected(#{board_position})"
    if tray_presenter.selected_square
      letter = tray_presenter.selected_square.letter
      return unless letter

      board_presenter.place_letter(board_position, letter)
      tray_presenter.place_letter(tray_presenter.selected_position, nil)
      tray_presenter.select_square(nil)
    else
      board_presenter.select_square(board_position)
    end
  end

  def tray_square_selected(col)
    puts "game_presenter#tray_square_selected(#{col})"
    if board_presenter.selected_square
      letter = board_presenter.selected_square.letter
      return unless letter

      position = board_presenter.selected_position
      board_presenter.place_letter(position, nil)
      tray_presenter.place_letter(col, letter)
      board_presenter.select_square(nil)
    else
      tray_presenter.select_square(col)
    end
  end
end