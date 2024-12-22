class PlayedWord
  attr_reader :player, :placed_letters, :time

  def initialize(player, placed_letters)
    @player = player
    @placed_letters = placed_letters
    @time = Time.now
  end

  def ==(other)
    other.is_a?(PlayedWord) && other.player == player && other.placed_letters == placed_letters
  end
end