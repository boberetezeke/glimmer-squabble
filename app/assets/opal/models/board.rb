require 'models/square'

class Board
  attr_reader :squares
  attr_reader :size

  def initialize(size)
    @size = size
    @squares = Array.new(size) { |row| Array.new(size) { |col| Square.new(row, col) } }
  end
end
