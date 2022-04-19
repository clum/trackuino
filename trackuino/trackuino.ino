/* trackuino copyright (C) 2010  EA5HAV Javi
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

/*
Christopher Lum Notes
---------------------

Version History
03/21/22: Started modifications
03/23/22: Position transmission via HX1 is working.  Able to consume packets via Direwolf.  Something seems off with temperature measurements.
03/27/22: Changed to interface with DS18B20 temperature sensors.  Can't seem to make this work via the APRS packet.
04/17/22: Confirmed to work.  Still couldn't get temperature sensors to work
04/18/22: Got temperature sensors working.  It turned out that I used the wrong value resistor for the sensor pullup resistor.
*/

// Mpide 22 fails to compile Arduino code because it stupidly defines ARDUINO 
// as an empty macro (hence the +0 hack). UNO32 builds are fine. Just use the
// real Arduino IDE for Arduino builds. Optionally complain to the Mpide
// authors to fix the broken macro.
#if (ARDUINO + 0) == 0
#error "Oops! We need the real Arduino IDE (version 22 or 23) for Arduino builds."
#error "See trackuino.pde for details on this"

// Refuse to compile on arduino version 21 or lower. 22 includes an 
// optimization of the USART code that is critical for real-time operation
// of the AVR code.
#elif (ARDUINO + 0) < 22
#error "Oops! We need Arduino 22 or 23"
#error "See trackuino.pde for details on this"

#endif


// Trackuino custom libs
#include "config.h"
#include "afsk_avr.h"
#include "afsk_pic32.h"
#include "aprs.h"
#include "buzzer.h"
#include "gps.h"
#include "pin.h"
#include "power.h"
#include "sensors_avr.h"
#include "sensors_pic32.h"

// Arduino/AVR libs
#if (ARDUINO + 1) >= 100
#  include <Arduino.h>
#else
#  include <WProgram.h>
#endif

//----------------------------
//DS18B20
#include <OneWire.h>
#include <DallasTemperature.h>
#define ONE_WIRE_BUS 2

// Setup a oneWire instance to communicate with any OneWire device
OneWire oneWire(ONE_WIRE_BUS);  

// Pass oneWire reference to DallasTemperature library
DallasTemperature sensors(&oneWire);
//----------------------------


// Module constants
static const uint32_t VALID_POS_TIMEOUT = 2000;  // ms

// Module variables
static int32_t next_aprs = 0;

void setup()
{
  pinMode(LED_PIN, OUTPUT);
  pin_write(LED_PIN, LOW);

  Serial.begin(GPS_BAUDRATE);
  #ifdef DEBUG_RESET
    Serial.println("RESET");
  #endif

  buzzer_setup();
  afsk_setup();
  gps_setup();
  sensors_setup();

  //BISEA: Start up the DallasTemperature sensor library
  sensors.begin();

  #ifdef DEBUG_SENS
    sensors.requestTemperatures(); 
    float temperatureA_c = sensors.getTempCByIndex(0);
    float temperatureB_c = sensors.getTempCByIndex(1);
  
    Serial.print(", TA=");
    Serial.print(temperatureA_c);

    Serial.print(", TB=");
    Serial.print(temperatureB_c);
    
    Serial.print(", Vin=");
    Serial.println(sensors_vin());
  #endif

  // Do not start until we get a valid time reference
  // for slotted transmissions.
  if (APRS_SLOT >= 0) {
    do {
      while (! Serial.available())
        power_save();
    } while (! gps_decode(Serial.read()));
    
    next_aprs = millis() + 1000 *
      (APRS_PERIOD - (gps_seconds + APRS_PERIOD - APRS_SLOT) % APRS_PERIOD);
  }
  else {
    next_aprs = millis();
  }  
  // TODO: beep while we get a fix, maybe indicating the number of
  // visible satellites by a series of short beeps?
}

void get_pos()
{
  // Get a valid position from the GPS
  int valid_pos = 0;
  uint32_t timeout = millis();

  #ifdef DEBUG_GPS
    Serial.println("\nget_pos()");
  #endif

  gps_reset_parser();

  do {
    if (Serial.available())
      valid_pos = gps_decode(Serial.read());
  } while ( (millis() - timeout < VALID_POS_TIMEOUT) && ! valid_pos) ;
   
  if (valid_pos) {
    if (gps_altitude > BUZZER_ALTITUDE) {
      buzzer_off();   // In space, no one can hear you buzz
    } else {
      buzzer_on();
    }
  }
}

void loop()
{
  // Time for another APRS frame
  if ((int32_t) (millis() - next_aprs) >= 0) {
    get_pos();
    aprs_send();
    next_aprs += APRS_PERIOD * 1000L;
    while (afsk_flush()) {
      power_save();
    }

  #ifdef DEBUG_MODEM
      // Show modem ISR stats from the previous transmission
      afsk_debug();
  #endif

  #ifdef DEBUG_SENS
    sensors.requestTemperatures(); 
    float temperatureA_c = sensors.getTempCByIndex(0);
    float temperatureB_c = sensors.getTempCByIndex(1);
  
    Serial.print(", TA=");
    Serial.print(temperatureA_c);

    Serial.print(", TB=");
    Serial.print(temperatureB_c);
    
    Serial.print(", Vin=");
    Serial.println(sensors_vin());
  #endif

  } else {
    // Discard GPS data received during sleep window
    while (Serial.available()) {
      Serial.read();
    }
  }

  power_save(); // Incoming GPS data or interrupts will wake us up
}
