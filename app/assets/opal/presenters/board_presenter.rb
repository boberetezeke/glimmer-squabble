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
        sp.on_select { |position| square_selected(position[:row], position[:col]) }
        sp
      end
    end
  end

  def on_select_square(&block)
    @on_select_square = block
  end

  def square_selected(row, col)
    puts "board_presenter#square_selected(#{row},#{col})"
    @on_select_square.call(row, col) if @on_select_square
  end

  def select_square(row, col)
    if row.nil?
      @square_presenters[@selected_square[0]][@selected_square[1]].select(false) if @selected_square
      @selected_square = nil
    else
      @square_presenters[@selected_square[0]][@selected_square[1]].select(false) if @selected_square
      if @selected_square == [row, col]
        @selected_square = nil
      else
        @square_presenters[row][col].select(true)
        @selected_square = [row, col]
      end
    end
  end

  def selected_square
    return nil unless @selected_square

    @board.squares[@selected_square[0]][@selected_square[1]]
  end

  def place_letter(row, col, letter)
    puts "board_presenter#place_letter(#{row},#{col},#{letter})"
    @square_presenters[row][col].letter = letter
  end
end
