class PlacedLetter
  attr_reader :letter, :position

  def initialize(position, letter)
    @position = position
    @letter = letter
  end

  def ==(other)
    other.is_a?(PlacedLetter) && other.position == position && other.letter == letter
  end

  def adjacent_positions(board_size)
    row, col = @position

    positions = []
    positions << [row - 1, col] if row > 0
    positions << [row + 1, col] if row < board_size - 1
    positions << [row, col - 1] if col > 0
    positions << [row, col + 1] if col < board_size - 1

    positions
  end

  def to_s
    "PlacedLetter(#{position}, #{letter})"
  end
end