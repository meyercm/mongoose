#include <Arduino.h>
#include <ESP8266WiFi.h>

#include <stdint.h>
#include "secret.h" //provides WIFI_SSID/WIFI_PASS

WiFiServer server(8022);

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(D0, OUTPUT);
  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);
  pinMode(D3, OUTPUT);
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
        } else if (line[0] == 'f') {
          digitalWrite(D3, 1);
          delay(300);
          digitalWrite(D3, 0);
        } else if (line[0] == 'b') {
          digitalWrite(D2, 1);
          delay(300);
          digitalWrite(D2, 0);
        } else if (line[0] == 'l') {
          digitalWrite(D1, 0);
          digitalWrite(D0, 1);
        } else if (line[0] == 'r') {
          digitalWrite(D0, 0);
          digitalWrite(D1, 1);
        } else if (line[0] == 's') {
          digitalWrite(D0, 0);
          digitalWrite(D1, 0);
        }
      }
    }
    delay(1); // give the web browser time to receive the data

    // close the connection:
    client.stop();
    Serial.println("[Client disconnected]");
  }
}
