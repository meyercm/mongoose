require_relative './keyboard'
require_relative './controls'
require_relative './control_mapping'

module Mongoose

  FORWARD_PIN = 11
  BACK_PIN = 12
  LEFT_PIN = 15
  RIGHT_PIN = 16
  HEADLIGHTS_PIN = 13


  cm = ControlMapping.new(FORWARD_PIN, BACK_PIN, LEFT_PIN, RIGHT_PIN, HEADLIGHTS_PIN)

  controls = Controls.new(cm)

  keyboard = Keyboard.new(controls)

  keyboard.get_keys
end
