class Square
  attr_accessor :value
  attr_reader :row, :col

  def initialize(row, col, value: nil)
    @row = row
    @col = col
    @value = (65 + (row * 3) + col).chr
  end
end
