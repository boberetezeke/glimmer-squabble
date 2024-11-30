require 'models/game'
require 'models/player'
require 'models/board'

class App
  attr_reader :game
  def initialize
    board = Board.new(3)
    steve = Player.new('Steve')
    angie = Player.new('Angie')
    @game = Game.new(board, [steve, angie])
  end
end