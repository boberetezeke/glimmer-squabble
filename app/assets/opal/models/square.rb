class Square
  attr_accessor :letter, :is_played, :modifier
  attr_reader :position

  LETTER_VALUES = {
    'A' => 1, 'B' => 3, 'C' => 3, 'D' => 2, 'E' => 1, 'F' => 4, 'G' => 2,
    'H' => 4, 'I' => 1, 'J' => 8, 'K' => 5, 'L' => 1, 'M' => 3, 'N' => 1,
    'O' => 1, 'P' => 3, 'Q' => 10, 'R' => 1, 'S' => 1, 'T' => 1, 'U' => 1,
    'V' => 4, 'W' => 4, 'X' => 8, 'Y' => 4, 'Z' => 10
  }

  def initialize(position, letter: nil, is_played: false, modifier: nil)
    @position = position
    @is_played = is_played
    @letter = letter
    @modifier = modifier
  end

  def empty?
    @letter.nil?
  end

  def has_unplayed_letter?
    @letter && !@is_played
  end

  def replaceable?
    has_unplayed_letter?
  end

  def value
    value_for(@letter)
  end

  def value_for(letter)
    LETTER_VALUES[letter&.upcase] || 0
  end
end