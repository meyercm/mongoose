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
      @subscriber.on_control_change(self)
    end

    def on_key_event(char)
      case char
      when :up
        @steering = :straight
        warn "steering straight"
      when :left
        @steering = :left
        warn "steering left"
      when :right
        @steering = :right
        warn "steering right"
      when 'r'
        @direction = (@direction == :forward) ? :reverse : :forward
        warn "set direction to #{@direction}"
      when 'h'
        @headlights_on = !@headlights_on
        warn "set headlights to #{@headlights_on}"
      when 'q'
        warn "quitting"
        @quit = true
      when '1'..'9'
        @power = (char.to_i - 1) * 10.0
        warn "power = #{@power}"
      when '0'
        warn 'full power'
        @power = 100.0
      else
        warn "ignored input #{char}"
      end
      return @subscriber.on_control_change(self)
    end
  end
end
