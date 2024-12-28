class ActionComponent
  include Glimmer::Web::Component

  option :action_presenter

  markup do
    div(style: { display: :flex }) do
      div do
        button 'pass'
        onclick do
          puts 'pass'
          action_presenter.pass_pressed
        end
      end
      div do
        button 'submit'
        onclick do
          puts 'submit'
          action_presenter.play_pressed
        end
      end
    end
  end
end
