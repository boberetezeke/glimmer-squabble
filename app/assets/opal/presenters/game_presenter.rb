require 'forwardable'

class GamePresenter
  extend Forwardable

  def_delegator :@game, :current_player
  def_delegator :@game, :players
  def_delegator :@game, :pass

  attr_reader :tray_presenter, :board_presenter

  def initialize(game)
    @game = game
    @tray_presenter = TrayPresenter.new(game.tray)
    @board_presenter = BoardPresenter.new(game.board)
  end

  def board_square_selected(row, col)
    return unless tray_presenter.selected_square

    letter = tray_presenter.selected_square.letter
    return unless letter

    board_presenter.place_letter(row, col, letter)
    tray_presenter.select_square(nil)
  end

  def tray_square_selected(index)
    return unless board_presenter.selected_square

    letter = board_presenter.selected_square.letter
    return unless letter

    tray_presenter.place_letter(index, letter)
    board_presenter.select_square(nil, nil)
  end
end