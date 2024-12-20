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
    @tray_presenter.on_select_square do |index|
      tray_square_selected(index)
    end
    @board_presenter.on_select_square do |row, col|
      board_square_selected(row, col)
    end
  end

  def board_square_selected(row, col)
    puts "game_presenter#board_square_selected(#{row}, #{col})"
    if tray_presenter.selected_square
      letter = tray_presenter.selected_square.letter
      return unless letter

      board_presenter.place_letter(row, col, letter)
      tray_presenter.select_square(nil)
    else
      board_presenter.select_square(row, col)
    end
  end

  def tray_square_selected(col)
    puts "game_presenter#tray_square_selected(#{col})"
    if board_presenter.selected_square
      letter = board_presenter.selected_square.letter
      return unless letter

      tray_presenter.place_letter(col, letter)
      board_presenter.select_square(nil, nil)
    else
      tray_presenter.select_square(col)
    end
  end
end