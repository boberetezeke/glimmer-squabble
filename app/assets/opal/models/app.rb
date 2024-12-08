class App
  attr_reader :game_presenter
  def initialize
    board = Board.new(3)
    steve = Player.new('Steve')
    angie = Player.new('Angie')
    game = Game.new(board, [steve, angie])
    @game_presenter = GamePresenter.new(game)
  end
end