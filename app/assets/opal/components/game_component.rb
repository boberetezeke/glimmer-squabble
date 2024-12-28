class GameComponent
  include Glimmer::Web::Component

  option :game_presenter

  markup do
    div(style: {display: 'flex'}) do
      game_presenter.player_presenters.each do |player_presenter|
        player_component player_presenter: player_presenter
      end
    end
    div do
      board_component board_presenter: game_presenter.board_presenter
    end
    hr
    div do
      tray_component tray_presenter: game_presenter.tray_presenter
    end
    div do
      action_component action_presenter: game_presenter.action_presenter
    end
    div do
      bag_component bag_presenter: game_presenter.bag_presenter
    end
  end
end
