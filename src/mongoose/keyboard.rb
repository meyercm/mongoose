require 'io/console'

# responsibilities:
# - capture keystrokes
# - advertise keystrokes

module Mongoose
  class Keyboard

    def initialize(subscriber)
      @subscriber = subscriber
      @running = false
      @escape_seq = 0
    end

    def stop
      @running = false
    end

    def get_keys
      @running = true
      while (@running) do
        char = STDIN.getch

        # Arrow keys look like ["\e", "[", <ABCD>]
        # if conditions below are a small state machine to track their arrival
        # (and to distinguish from "[" and "A" ...)
        if (@escape_seq == 0 and char == "\e") then
          @escape_seq = 1
          next
        end
        if (@escape_seq == 1 and char == '[') then
          @escape_seq = 2
          next
        end
        if (@escape_seq == 2) then
          case char
          when 'A'; char = :up
          when 'B'; char = :down
          when 'C'; char = :right
          when 'D'; char = :left
          end
        end

        @escape_seq = 0
        # only way out of our loop is on the subscriber's command
        @running = @subscriber.on_key_event(char)
      end
    end

    # included testing subscriber, prints chars to the screen.
    # quits on keystroke 'q'
    class EchoSubscriber
      # char can be a char, or (:up | :down | :left | :right)
      def key_event(char)
        p char.inspect
        return false if char == 'q'
        return true
      end
    end

  end
end
