class App
  attr_reader :game_presenter
  def initialize
    board = Board.new(15)
    bag = Bag.new('MNOPQRS')
    tray = Tray.new(7, ['A', 'B', 'C'])
    steve = Player.new('Steve')
    angie = Player.new('Angie', letters: ['D', 'E', 'F'])
    game = Game.new(board, bag, tray, [steve, angie])
    @game_presenter = GamePresenter.new(game)
  end
end