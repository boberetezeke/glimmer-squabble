class SquareComponent
  include Glimmer::Web::Component

  option :square_presenter

  markup do
    div do
      onclick do
        square_presenter.selected
      end
      inner_text <= [square_presenter, :letter]
    end
  end
end
