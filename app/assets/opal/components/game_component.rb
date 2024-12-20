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
    hr
    div do
      tray_component tray_presenter: game_presenter.tray_presenter
    end
    div do
      player_component player_presenter: game_presenter.player_presenter
    end
  end
end
