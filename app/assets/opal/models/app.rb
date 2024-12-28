class App
  attr_reader :game_presenter
  def initialize
    board = Board.new(3)
    tray = Tray.new(3, ['A', 'B', 'C'])
    steve = Player.new('Steve')
    angie = Player.new('Angie', letters: ['D', 'E', 'F'])
    game = Game.new(board, tray, [steve, angie])
    @game_presenter = GamePresenter.new(game)
  end
end