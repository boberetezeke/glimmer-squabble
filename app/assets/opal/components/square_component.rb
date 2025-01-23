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
      class_name('square_played') <= [square_presenter, :is_played]
      # class_name('double_letter') <= [square_presenter, :is_double_letter]
      # class_name('triple_letter') <= [square_presenter, :is_triple_letter]
      class_name('double_word') <= [square_presenter, :is_double_word]
      class_name('triple_word') <= [square_presenter, :is_triple_word]
      class_name('start_square') <= [square_presenter, :is_start_square]
    end
  end
end
