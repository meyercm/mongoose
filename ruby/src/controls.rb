# responsibilities: interpret keystrokes, advertise control status

module Mongoose
  class Controls
    attr_accessor :direction, :power, :steering, :headlights_on, :quit

    def initialize(subscriber)
      @subscriber = subscriber
      @direction = :forward
      @power = 0
      @steering = :straight
      @headlights_on = false
      @quit = false
      subscriber.on_controls(self)
    end

    def on_key_event(char)
      case char
      when :up
        @steering = :straight
      when :left
        @steering = :left
      when :right
        @steering = :right
      when 'r'
        @direction = (@direction == :forward) ? :reverse : :forward
      when 'h'
        @headlights_on = !@headlights_on
      when 'q'
        @quit = true
      when '1'..'9'
        @power = (char.to_i - 1) * 10.0
      when '0'
        @power = 100.0
      end
      return subscriber.on_controls(self)
    end
  end
end
