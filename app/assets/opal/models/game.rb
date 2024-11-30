require 'models/board'
class Game
  attr_reader :board
  def initialize(board, players)
    @board = board
    @players = players
  end
end