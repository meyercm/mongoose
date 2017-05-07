require 'rpi_gpio'

module Mongoose
  class ControlMapping

    PWM_FREQ = 1000

    def initialize(forward, back, left, right, headlights)
      @forward_pin_num = forward
      @back_pin_num = back
      @left_pin_num = left
      @right_pin_num = right
      @headlights_pin_num = headlights
      setup_pins
    end

    def setup_pins
      RPi::GPIO.set_numbering :board
      RPi::GPIO.setup @forward_pin_num, :as => :output, :initialize => :low
      RPi::GPIO.setup @back_pin_num, :as => :output, :initialize => :low
      RPi::GPIO.setup @left_pin_num, :as => :output, :initialize => :low
      RPi::GPIO.setup @right_pin_num, :as => :output, :initialize => :low
      RPi::GPIO.setup @headlights_pin_num, :as => :output, :initialize => :low
      @forward_pwm = RPi::GPIO::PWM.new(@forward_pin_num, PWM_FREQ)
      @back_pwm = RPi::GPIO::PWM.new(@back_pin_num, PWM_FREQ)
      @left_pwm = RPi::GPIO::PWM.new(@left_pin_num, PWM_FREQ)
      @right_pwm = RPi::GPIO::PWM.new(@right_pin_num, PWM_FREQ)
      @headlights_pwm = RPi::GPIO::PWM.new(@headlights_pin_num, PWM_FREQ)
    end

    def on_control_change(controls)
      # forward / reverse and speed
      if controls.direction == :forward then
        set_power(@forward_pwm, controls.power)
        @back_pwm.stop if @back_pwm.running?
        @forward_pwm.start if !@forward_pwm.running?
      else
        set_power(@back_pwm, controls.power)
        @forward_pwm.stop if @forward_pwm.running?
        @back_pwm.start if !@back_pwm.running?
      end

      # steering
      case controls.direction
      when :left
        off(@right_pwm)
        on(@left_pwm)
      when :right
        off(@left_pwm)
        on(@right_pwm)
      else
        off(@left_pwm)
        off(@right_pwm)
      end

      # headlights and other peripherals
      if controls.headlights_on then
        on(@headlights_pwm)
      else
        off(@headlights_pwm)
      end

      return !controls.quit
    end # on_control_change/1



    # adjustments for the fact that their micro runs at 3.3, and we run at 5.0
    # so fake it by dividing the duty cycle further
    TARGET_VOLTAGE = 3.3
    SOURCE_VOLTAGE = 5.0
    FULL_RATE = TARGET_VOLTAGE / SOURCE_VOLTAGE

    def off(pin)
      pin.stop
    end
    def on(pin)
      pin.duty_cycle = FULL_RATE
      pin.start
    end
    def set_power(pin, power)
      pin.duty_cycle = FULL_RATE * power
    end
  end # class
end # module
