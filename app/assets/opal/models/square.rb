class Square
  attr_accessor :letter
  attr_reader :position

  def initialize(position, letter: nil)
    @position = position
    @letter = letter
  end
end