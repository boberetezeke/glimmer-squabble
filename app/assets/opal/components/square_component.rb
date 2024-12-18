class SquareComponent
  include Glimmer::Web::Component

  option :square_presenter

  markup do
    div do
      onclick do
        puts 'clicked'
      end
      inner_text <= [square_presenter, :letter]
    end
  end
end
