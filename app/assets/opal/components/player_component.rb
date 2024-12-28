class PlayerComponent
  include Glimmer::Web::Component

  option :player_presenter

  markup do
    div do
      "Player:"
    end
    div do
      inner_text <= [player_presenter, :name]
    end
    div do
      "Score:"
    end
    div do
      inner_text <= [player_presenter, :score]
    end
  end
end
