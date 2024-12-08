class TrayComponent
  include Glimmer::Web::Component

  option :player

  markup do
    div(style: { display: :flex }) do
      player.squares.each do |square|
        div do
          square_component square: square
        end
      end
    end
  end
end
