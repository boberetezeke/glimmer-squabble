require 'models/board'
class Game
  attr_reader :board, :players
  def initialize(board, players)
    @board = board
    @players = players
    @current_player_index = 0
  end

  def current_player
    @players[@current_player_index]
  end
end