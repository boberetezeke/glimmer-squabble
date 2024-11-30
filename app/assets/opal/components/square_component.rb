class SquareComponent
  include Glimmer::Web::Component

  option :square

  markup do
    div do
      inner_text <= [square, :value]
    end
  end
end
