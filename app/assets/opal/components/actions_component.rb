class ActionsComponent
  include Glimmer::Web::Component

  option :player

  markup do
    div(style: { display: :flex }) do
      div do
        button 'pass'
      end
      div do
        button 'submit'
      end
    end
  end
end
