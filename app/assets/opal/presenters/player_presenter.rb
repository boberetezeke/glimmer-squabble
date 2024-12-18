class PlayerPresenter
  attr_reader :player

  def initialize(player)
    @player = player
  end

  def name
    player.name
  end

  def score
    player.score
  end
end