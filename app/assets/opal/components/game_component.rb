require 'components/score_component'
require 'components/board_component'
require 'components/shelf_component'
require 'components/actions_component'

class GameComponent
  include Glimmer::Web::Component

  option :game

  markup do
    div(style: {display: 'flex'}) do
      game.players.each do |player|
        score_component player: player
      end
    end
    div do
      board_component board: game.board
    end
    div do
      shelf_component player: game.current_player
    end
    div do
      actions_component player: game.current_player
    end
  end
end
