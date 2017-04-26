## Mongoose

### Concept:

Combine a $30 [remote control truck], the popular ESP8266 [microcontroller], and
an old [camera module] laying around into an inexpensive ROV.

### Approach:

The remote control truck control circuitry already has an MCU and a pair of
motor controllers (forward/back, left/right). Adding jumpers from the motor
controller inputs to our micro lets us usurp control of the vehicle, while
retaining the original remote's functionality.

### Tasks:

* Physical
  - [x] Identify control traces
  - [x] Solder jumpers to power/ground/inputs
  - [ ] Mount Camera Module
  - [ ] Add LED headlights
  - [ ] Mount micro
* ESP8266
  - [x] Establish programming environment
    * figure out OTA programming
    * decide between LUA / C
  - [ ] Setup I2C connection to camera module
  - [ ] Serve images via http
  - [ ] Accept commands via (http / udp)
* Camera module
  - [ ] Retrieve images
  - [ ] Setup camera parameters

### Lessons Learned:

* analogWrite(127) is too small to make reverse work right.
* analogWrite(512) makes reverse work ok, and noticably different from 3.3 raw
* aW(512) makes wheels turn a bit, but not halfway, and they whine funny.

### Control Wiring

yellow: left
green: right
blue: back
purple: forward

[remote control truck]: https://www.amazon.com/gp/product/B00Y53XH9O
[microcontroller]: https://www.amazon.com/gp/product/B010O1G1ES
[camera module]: https://www.amazon.com/Arducam-Megapixels-OV7670-640x480-Compatiable/dp/B013JRXG24
