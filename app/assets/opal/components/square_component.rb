class SquareComponent
  include Glimmer::Web::Component

  option :square_presenter

  markup do
    div(class: 'square') do
      onclick do
        puts "click"
        square_presenter.selected
      end
      inner_text <= [square_presenter, :letter]
      class_name('square_selected') <= [square_presenter, :is_selected]
    end
  end
end
