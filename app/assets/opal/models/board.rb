class Board
  attr_reader :size, :squares

  def initialize(size)
    @size = size
    @squares = Array.new(size) do |row|
      Array.new(size) do |col|
        Square.new
      end
    end
  end

  def select_square(row, col)
    @squares[row][col].select
  end

  def selected_square

  end
end
