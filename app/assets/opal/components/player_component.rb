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

    div(style: { display: :flex }) do
      div do
        button 'pass'
        onclick do
          puts 'pass'
          player_presenter.pass_pressed
        end
      end
      div do
        button 'submit'
        onclick do
          puts 'submit'
          player_presenter.play_pressed
        end
      end
    end
  end
end
