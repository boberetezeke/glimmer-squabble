class Square
  attr_accessor :letter, :is_played
  attr_reader :position

  def initialize(position, letter: nil, is_played: false)
    @position = position
    @is_played = is_played
    @letter = letter
  end
end