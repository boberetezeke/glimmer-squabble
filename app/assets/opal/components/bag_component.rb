require 'forwardable'
class BagComponent
  include Glimmer::Web::Component

  option :bag_presenter

  markup do
    div do
      "Bag:"
    end
    div do
      inner_text <= [bag_presenter, :letters]
    end
  end
end

