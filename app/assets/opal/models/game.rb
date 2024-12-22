class Game
  attr_reader :board, :tray, :players
  def initialize(board, tray, players)
    @board = board
    @tray = tray
    @players = players
    @current_player_index = 0
  end

  def current_player
    @players[@current_player_index]
  end

  def pass
    @current_player_index = (@current_player_index + 1) % players.size
  end
end