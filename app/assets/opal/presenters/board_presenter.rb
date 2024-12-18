require 'forwardable'

class BoardPresenter
  extend Forwardable

  def_delegator :@board, :size
  def_delegator :@board, :squares

  attr_reader :square_presenters

  def initialize(board)
    @board = board
    @square_presenters = Array.new(board.size) do |row|
      Array.new(board.size) do |col|
        sp = SquarePresenter.new(board.squares[row][col])
        sp.on_select { |x, y| select_square(x, y, notify_on_select: true) }
        sp
      end
    end
  end

  def on_select_square(&block)
    @on_select_square = block
  end

  def select_square(x, y, notify_on_select: false)
    @selected_square = x.nil? ? nil : [x, y]
    @on_select_square.call(x, y) if notify_on_select && @on_select_square
  end

  def selected_square
    return nil unless @selected_square

    @board.squares[@selected_square[0]][@selected_square[1]]
  end

  def place_letter(row, col, letter)
    @board.squares[row][col].letter = letter
  end
end
