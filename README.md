## Mongoose

### Concept:

Combine a $30 [remote control truck], the popular ESP8266 [microcontroller], and
an old [camera module] laying around into an inexpensive ROV.

### Initial Approach:

The remote control truck control circuitry already has an MCU and a pair of
motor controllers (forward/back, left/right). Adding jumpers from the motor
controller inputs to our micro lets us usurp control of the vehicle, while
retaining the original remote's functionality.

### Problems:

The camera module needs *lots* of pins on the micro: an 8 pin parallel data
interface, 2 pins of control I2C, and several clock pins.

### New Approach:

Give up on the camera module, the ESP is short on pins.  Enter the Raspberry Pi
Zero W ($24 [pi zero kit] at amazon), with the arducam [pi camera] module ($17).

Using a pi with wifi lets us discard the ESP8266, but a new problem arises: the
pi does not have an onboard voltage regulator.  My hack was to take a spare 5v
arduino nano, and wire the R/C car's power line at 7.2v to the Arduino's VIN,
and pass the 5v onward to the pi.

### Lessons Learned:

* The turning radius on the car is crap, so pwm on the steering motor is dumb.
* The Pi cam has a very noticable delay before capturing a photo.
* the Pi Zero W wifi range is pretty limited. Should have configured multiple APs

### Control Wiring

TODO: find Juliet's cheat sheet and copy the notes down here.
TODO: post a schematic of the wiring.
TODO: post some pictures of the completed vehicle.

### NOTES FROM PI:

need to setup the place to save:
`mkdir -p /tmp/stream`

start saving pictures from picam:
`raspistill --nopreview -w 1280 -h 720 -q 25 -bm  -o /tmp/stream/pic.jpg -tl 500 -t 9999999 -th 0:0:0 -md 1 &`

start mjpg_streamer:
`LD_LIBRARY_PATH=/usr/local/lib mjpg_streamer -i "input_file.so -f /tmp/stream -n pic.jpg" -o "output_http.so -w /usr/local/www"`

run our software:
`ruby src/mongoose.rb`

[remote control truck]: https://www.amazon.com/gp/product/B00Y53XH9O
[microcontroller]: https://www.amazon.com/gp/product/B010O1G1ES
[camera module]: https://www.amazon.com/Arducam-Megapixels-OV7670-640x480-Compatiable/dp/B013JRXG24
[pi zero kit]: https://www.amazon.com/gp/product/B06XCYGP27
[pi camera]: https://www.amazon.com/gp/product/B01LY05LOE
