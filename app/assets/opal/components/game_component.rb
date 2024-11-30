require 'components/board_component'
class GameComponent
  include Glimmer::Web::Component

  option :game

  markup do
    # div do
    #   scores_component game.scores
    # end
    div do
      board_component board: game.board
    end
    # div do
    #   shelf_component game.shelf
    # end
    # div do
    #   actions_component game.actions
    # end
  end
end
