class Square
  attr_accessor :letter, :is_played
  attr_reader :position

  def initialize(position, letter: nil, is_played: false)
    @position = position
    @is_played = is_played
    @letter = letter
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
end