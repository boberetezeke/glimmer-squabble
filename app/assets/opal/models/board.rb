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
end
