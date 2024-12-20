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
    @on_select_square.call([row, col]) if @on_select_square
  end

  def select_square(board_position)
    row, col = board_position
    if row.nil?
      @square_presenters[@selected_position[0]][@selected_position[1]].select(false) if @selected_position
      @selected_position = nil
    else
      @square_presenters[@selected_position[0]][@selected_position[1]].select(false) if @selected_position
      if @selected_position == [row, col]
        @selected_position = nil
      else
        @square_presenters[row][col].select(true)
        @selected_position = [row, col]
      end
    end
  end

  def selected_square
    return nil unless @selected_position

    @board.squares[@selected_position[0]][@selected_position[1]]
  end

  def selected_position
    @selected_position
  end

  def place_letter(position, letter)
    row, col = position
    puts "board_presenter#place_letter(#{row},#{col},#{letter})"
    @square_presenters[row][col].letter = letter
  end
end
