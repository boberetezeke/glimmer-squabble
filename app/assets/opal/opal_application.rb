require "opal"

require 'glimmer-dsl-web'

include Glimmer

class A
  attr_accessor :x
  def initialize(x)
    @x = x
  end
end

a = A.new(5)


class BoardComponent
  include Glimmer::Web::Component

  option :board

  markup do
    table do
      board.size.times do |row_index|
        tr do
          board.size.times do |col_index|
            td do
              square_component(square: board.squares[row_index][col_index])
            end
          end
        end
      end
    end
  end
end

class SquareComponent
  include Glimmer::Web::Component

  option :square

  markup do
    div do
      inner_text <= [square, :value]
    end
  end
end

class Square
  attr_accessor :value
  attr_reader :row, :col

  def initialize(row, col, value: nil)
    @row = row
    @col = col
    @value = (65 + (row * 3) + col).chr
  end
end

class Board
  attr_reader :squares
  attr_reader :size

  def initialize(size)
    @size = size
    @squares = Array.new(size) { |row| Array.new(size) { |col| Square.new(row, col) } }
  end
end

board = Board.new(3)

Document.ready? do
  div do
    board_component(board: board)
    # table do
    #   3.times do |row_index|
    #     tr do
    #       3.times do |col_index|
    #         td do
    #           square_component(square: board.squares[row_index][col_index])
    #         end
    #       end
    #     end
    #   end
    # end
    # inner_text <= [a, :x]
  end
end

# class FancyDiv
#   include Glimmer::Web::Component
#
#   option :some_a
#
#   markup do
#     div do
#       inner_text <= [some_a, :x]
#     end
#   end
# end
#
# class PlainDiv
#   include Glimmer::Web::Component
#
#   markup do
#     h1('goodbye')
#   end
# end

# Document.ready? do
  # This will hook into element #app-container and then build HTML inside it using Ruby DSL code
  # address.text = 'some text'
  # div {
  #   label(class: 'greeting') {
  #     'Hello, Worldy!'
  #   }
  #   button('Greet') {
  #     onclick do
  #       $$.alert('Hello, Button!')
  #       address.text = 'clicked-' + address.text
  #     end
  #   }
  #   div {
  #     inner_text <= [address, :text]
  #   }
  # }
  #
  # fancy_div(some_text: a).render
#   plain_div.render
# end

Address = Struct.new(:street, :street2, :city, :state, :zip_code, :billing_and_shipping, keyword_init: true) do
  STATES = {
    "AK"=>"Alaska",
    "AL"=>"Alabama",
  }

  def state_code
    STATES.invert[state]
  end

  def state_code=(value)
    self.state = STATES[value]
  end

  def summary
    string_attributes = to_h.except(:billing_and_shipping)
    summary = string_attributes.values.map(&:to_s).reject(&:empty?).join(', ')
    summary += " (Billing & Shipping)" if billing_and_shipping
    summary
  end
end

@address = Address.new(
  street: '123 Main St',
  street2: 'Apartment 3C, 2nd door to the right',
  city: 'San Diego',
  state: 'California',
  zip_code: '91911',
  billing_and_shipping: true,
  )

# include Glimmer
#
# Document.ready? do
#   div {
#     div(style: 'display: grid; grid-auto-columns: 80px 260px;') { |address_div|
#       # label('Street: ', for: 'street-field')
#       # input(id: 'street-field') {
#       #   # Bidirectional Data-Binding with <=> ensures input.value and @address.street
#       #   # automatically stay in sync when either side changes
#       #   value <=> [@address, :street]
#       # }
#
#       # label('Street 2: ', for: 'street2-field')
#       # textarea(id: 'street2-field') {
#       #   value <=> [@address, :street2]
#       # }
#       #
#       # label('City: ', for: 'city-field')
#       # input(id: 'city-field') {
#       #   value <=> [@address, :city]
#       # }
#       #
#       # label('State: ', for: 'state-field')
#       # select(id: 'state-field') {
#       #   Address::STATES.each do |state_code, state|
#       #     option(value: state_code) { state }
#       #   end
#       #
#       #   value <=> [@address, :state_code]
#       # }
#       #
#       # label('Zip Code: ', for: 'zip-code-field')
#       # input(id: 'zip-code-field', type: 'number', min: '0', max: '99999') {
#       #   # Bidirectional Data-Binding with <=> ensures input.value and @address.zip_code
#       #   # automatically stay in sync when either side changes
#       #   # on_write option specifies :to_s method to invoke on value before writing to model attribute
#       #   # to ensure the numeric zip code value is stored as a String
#       #   value <=> [@address, :zip_code,
#       #              on_write: :to_s,
#       #   ]
#       # }
#
#       # div(style: 'grid-column: 1 / span 2') {
#       #   input(id: 'billing-and-shipping-field', type: 'checkbox') {
#       #     checked <=> [@address, :billing_and_shipping]
#       #   }
#       #   label(for: 'billing-and-shipping-field') {
#       #     'Use this address for both Billing & Shipping'
#       #   }
#       # }
#       #
#       # # Programmable CSS using Glimmer DSL for CSS
#       # style {
#       #   # `r` is an alias for `rule`, generating a CSS rule
#       #   r("#{address_div.selector} *") {
#       #     margin '5px'
#       #   }
#       #   r("#{address_div.selector} input, #{address_div.selector} select") {
#       #     grid_column '2'
#       #   }
#       # }
#     }
#
#     div {
#       # Unidirectional Data-Binding is done with <= to ensure @address.summary changes
#       # automatically update div.inner_text
#       # (computed by changes to address attributes, meaning if street changes,
#       # @address.summary is automatically recomputed.)
#       # inner_text <= [@address, :summary,
#       #                computed_by: @address.members + ['state_code'],
#       inner_text <= [@address, :street]
#     }
#   }
# end