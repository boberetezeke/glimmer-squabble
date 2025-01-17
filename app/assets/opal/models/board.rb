class Board
  attr_reader :size, :squares

  def initialize(size)
    @size = size
    @squares = Array.new(size) do |row|
      Array.new(size) do |col|
        Square.new([row, col])
      end
    end
  end

  def start_square_position
    @squares.each_with_index do |row, row_index|
      row.each_with_index do |square, col_index|
        return [row_index, col_index] if square.modifier&.start_square?
      end
    end
    nil
  end
end
