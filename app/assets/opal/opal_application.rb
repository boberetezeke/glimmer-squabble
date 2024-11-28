require "opal"

require 'glimmer-dsl-web'

include Glimmer

Document.ready? do
  # This will hook into element #app-container and then build HTML inside it using Ruby DSL code
  div {
    label(class: 'greeting') {
      'Hello, Worldy!'
    }
  }
end

# Uncomment the following to print out you're hello-world with Opal:
#
#   puts "hello world!"
#
# The following will append a hello-world to your <body> element:
#
#   require "native"
#   $$[:document].addEventListener :DOMContentLoaded do
#     $$[:document][:body][:innerHTML] = '<h2>Hello World!</h2>'
#   end
