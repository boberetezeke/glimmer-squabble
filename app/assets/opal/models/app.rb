class App
  attr_reader :game_presenter
  def initialize
    board = Board.new(15)
    board.squares[7][7].modifier = SquareModifier.new(SquareModifier::START_SQUARE)
    [[0,0], [0,7], [0,14], [7,0], [7,14], [14,0], [14,7], [14,14]].each do |row, col|
      board.squares[row][col].modifier = SquareModifier.new(SquareModifier::TRIPLE_WORD)
    end
    [
      [1,1], [2,2], [3,3], [4,4], [5,5], [1,13], [2,12], [3,11], [4,10], [5,9],
      [9,9], [10,10], [11,11], [12,12], [13,13], [9,5], [10,4], [11,3], [12,2], [13,1]
    ].each do |row, col|
      board.squares[row][col].modifier = SquareModifier.new(SquareModifier::DOUBLE_WORD)
    end

    bag = Bag.new('MNOPQRS')
    tray = Tray.new(7, ['A', 'B', 'C'])
    steve = Player.new('Steve')
    angie = Player.new('Angie', letters: ['D', 'E', 'F'])
    game = Game.new(board, bag, tray, [steve, angie])
    @game_presenter = GamePresenter.new(game)
  end
end