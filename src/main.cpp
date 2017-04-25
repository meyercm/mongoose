#include <Arduino.h>
#include <ESP8266WiFi.h>

#include <stdint.h>
#include "secret.h" //provides WIFI_SSID/WIFI_PASS

WiFiServer server(8022);

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(D1, OUTPUT);
  analogWrite(D1, 127);
  digitalWrite(LED_BUILTIN, HIGH);
  Serial.begin(115200);
  delay(100);

  // We start by connecting to a WiFi network

  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(WIFI_SSID);

  WiFi.begin(WIFI_SSID, WIFI_PASS);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  digitalWrite(LED_BUILTIN, LOW);
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  server.begin();
}

void loop(){
  WiFiClient client = server.available();
  // wait for a client (web browser) to connect
  if (client) {
    Serial.println("\n[Client connected]");
    while (client.connected()) {
      // read line by line what the client \is requesting
      if (client.available()) {
        String line = client.readStringUntil('\n');
        Serial.println(line);
        client.println(line);
        if (line.length() == 5 && line[0] == 'q') {
          break;
        }
      }
    }
    delay(1); // give the web browser time to receive the data

    // close the connection:
    client.stop();
    Serial.println("[Client disconnected]");
  }
}
