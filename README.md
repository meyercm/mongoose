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
  - [ ] Solder jumpers to power/ground/inputs
  - [ ] Mount Camera Module
  - [ ] Add LED headlights
  - [ ] Mount micro
* ESP8266
  - [ ] Establish programming environment
    * figure out OTA programming
    * decide between LUA / C
  - [ ] Setup I2C connection to camera module
  - [ ] Serve images via http
  - [ ] Accept commands via (http / udp)
* Camera module
  - [ ] Retrieve images
  - [ ] Setup camera parameters



[remote control truck]: https://www.amazon.com/gp/product/B00Y53XH9O
[microcontroller]: https://www.amazon.com/gp/product/B010O1G1ES
[camera module]: https://www.amazon.com/Arducam-Megapixels-OV7670-640x480-Compatiable/dp/B013JRXG24
