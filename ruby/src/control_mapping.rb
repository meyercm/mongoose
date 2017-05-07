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
      RPi::GPIO.setup forward_pin_num, :as => :output, :initialize => :low
      RPi::GPIO.setup back_pin_num, :as => :output, :initialize => :low
      RPi::GPIO.setup left_pin_num, :as => :output, :initialize => :low
      RPi::GPIO.setup right_pin_num, :as => :output, :initialize => :low
      RPi::GPIO.setup headlights_pin_num, :as => :output, :initialize => :low
      @forward_pwm = RPi::GPIO::PWM.new(forward_pin_num, PWM_FREQ)
      @back_pwm = RPi::GPIO::PWM.new(back_pin_num, PWM_FREQ)
    end

    def on_control_change(controls)
      # forward / reverse and speed
      if controls.direction == :forward then
        @forward_pwm.duty_cycle controls.power
        if @back_pwm.running? then
          @back_pwm.stop
          @forward_pwm.start
        end
      else
        @back_pwm.duty_cycle controls.power
        if @forward_pwm.running? then
          @forward_pwm.stop
          @back_pwm.start
        end
      end

      # steering
      case controls.direction
      when :left
        Rpi::GPIO.set_low(@right_pin_num)
        Rpi::GPIO.set_high(@left_pin_num)
      when :right
        Rpi::GPIO.set_low(@left_pin_num)
        Rpi::GPIO.set_high(@right_pin_num)
      else
        Rpi::GPIO.set_low(@left_pin_num)
        Rpi::GPIO.set_low(@right_pin_num)
      end

      # headlights and other peripherals
      if controls.headlights_on then
        Rpi::GPIO.set_high(@headlights_pin_num)
      else
        Rpi::GPIO.set_low(@headlights_pin_num)
      end

      return !controls.quit
    end # on_control_change/1
  end # class
end # module
