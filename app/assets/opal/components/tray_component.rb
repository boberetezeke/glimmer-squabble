class TrayComponent
  include Glimmer::Web::Component

  option :tray_presenter

  markup do
    div(style: { display: :flex }, class: 'tray') do
      tray_presenter.square_presenters.each do |square_presenter|
        div do
          square_component square_presenter: square_presenter
        end
      end
    end
  end
end
