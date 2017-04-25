#include <Arduino.h>

#include <stdint.h>


bool on = false;
void setup(){
  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop(){
  if (Serial.available()){
    Serial.write(Serial.read());
  }
  delay(300);
  digitalWrite(LED_BUILTIN, on);
  on = !on;
}
