class SquareComponent
  include Glimmer::Web::Component

  option :square_presenter

  markup do
    div do
      inner_text <= [square_presenter, :value]
    end
  end
end
