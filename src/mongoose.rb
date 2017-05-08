require_relative './mongoose/keyboard'
require_relative './mongoose/intentions'
require_relative './mongoose/control_mapping'

# Entry point for the app.

# Responsibilities:
# - defining which pin is user for which purpose
# - instantiating objects
# - wiring all the parts together

module Mongoose

  FORWARD_PIN = 11
  BACK_PIN = 12
  LEFT_PIN = 15
  RIGHT_PIN = 16
  HEADLIGHTS_PIN = 13


  cm = ControlMapping.new(FORWARD_PIN, BACK_PIN, LEFT_PIN, RIGHT_PIN, HEADLIGHTS_PIN)

  intentions = Intentions.new(cm)

  keyboard = Keyboard.new(intentions)

  keyboard.get_keys
end
