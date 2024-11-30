class ScoreComponent
  include Glimmer::Web::Component

  option :player

  markup do
    div do
      div do
        player.name
      end
      div do
        player.score.to_s
      end
    end
  end
end

