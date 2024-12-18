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
        sp.on_select { |position| select_square(position[:row], position[:col], notify_on_select: true) }
        sp
      end
    end
  end

  def on_select_square(&block)
    @on_select_square = block
  end

  def select_square(row, col, notify_on_select: false)
    puts "board_component#select_square(#{row}, #{col})"
    @selected_square = row.nil? ? nil : [row, col]
    @on_select_square.call(row, col) if notify_on_select && @on_select_square
  end

  def selected_square
    return nil unless @selected_square

    @board.squares[@selected_square[0]][@selected_square[1]]
  end

  def place_letter(row, col, letter)
    @board.squares[row][col].letter = letter
  end
end
