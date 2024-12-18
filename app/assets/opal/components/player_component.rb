class ActionsComponent
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
        end
      end
      div do
        button 'submit'
        onclick do
          puts 'submit'
        end
      end
    end
  end
end
