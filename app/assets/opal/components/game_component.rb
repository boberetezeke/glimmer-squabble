class GameComponent
  include Glimmer::Web::Component

  option :game_presenter

  markup do
    # div(style: {display: 'flex'}) do
    #   game_presenter.players.each do |player|
    #     score_component player: player
    #   end
    # end
    div do
      board_component board_presenter: game_presenter.board_presenter
    end
    div do
      tray_component player: game_presenter.current_player
    end
    div do
      actions_component player: game_presenter.current_player
    end
  end
end
