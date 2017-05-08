# responsibilities:
# - transform keystrokes into intentions
# - advertise intentions to subscriber

module Mongoose
  class Intentions
    attr_accessor :direction, :power, :steering, :headlights_on, :quit

    def initialize(subscriber)
      @subscriber = subscriber
      @direction = :forward
      @power = 0
      @steering = :straight
      @headlights_on = false
      @quit = false
      # initial call to the subscriber to let ^ be the initial intentions
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
        # TODO: better formula please... the top end of the range is the dynamic
        # part.
        @power = (char.to_i - 1) * 10.0 # 0 - 80.0
        warn "power = #{@power}"
      when '0'
        warn 'full power'
        @power = 100.0
      else
        # early out if we have nothing to advertise
        warn "ignored input #{char}"
        return
      end

      return @subscriber.on_control_change(self)
    end
  end
end
