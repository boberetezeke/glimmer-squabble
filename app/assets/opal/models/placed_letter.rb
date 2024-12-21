class PlacedLetter
  attr_reader :letter, :position

  def initialize(position, letter)
    @position = position
    @letter = letter
  end

  def ==(other)
    other.is_a?(PlacedLetter) && other.position == position && other.letter == letter
  end

  def to_s
    "PlacedLetter(#{position}, #{letter})"
  end
end