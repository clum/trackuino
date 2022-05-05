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

#include "config.h"
#include "ax25.h"
#include "gps.h"
#include "aprs.h"
#include "sensors_avr.h"
#include "sensors_pic32.h"
#include <stdio.h>
#include <stdlib.h>
#if (ARDUINO + 1) >= 100
#  include <Arduino.h>
#else
#  include <WProgram.h>
#endif

//Update: extern sensor
#include <DallasTemperature.h>
extern DallasTemperature sensors;

// Module functions
float meters_to_feet(float m)
{
  // 10000 ft = 3048 m
  return m / 0.3048;
}

// Exported functions
void aprs_send()
{
  char temp[12];                   // Temperature (int/ext)
  const struct s_address addresses[] = { 
    {D_CALLSIGN, D_CALLSIGN_ID},  // Destination callsign
    {S_CALLSIGN, S_CALLSIGN_ID},  // Source callsign (-11 = balloon, -9 = car)
#ifdef DIGI_PATH1
    {DIGI_PATH1, DIGI_PATH1_TTL}, // Digi1 (first digi in the chain)
#endif
#ifdef DIGI_PATH2
    {DIGI_PATH2, DIGI_PATH2_TTL}, // Digi2 (second digi in the chain)
#endif
  };

  ax25_send_header(addresses, sizeof(addresses)/sizeof(s_address));
  ax25_send_byte('/');                // Report w/ timestamp, no APRS messaging. $ = NMEA raw data
  // ax25_send_string("021709z");     // 021709z = 2nd day of the month, 17:09 zulu (UTC/GMT)
  ax25_send_string(gps_time);         // 170915 = 17h:09m:15s zulu (not allowed in Status Reports)
  ax25_send_byte('h');
  ax25_send_string(gps_aprs_lat);     // Lat: 38deg and 22.20 min (.20 are NOT seconds, but 1/100th of minutes)
  ax25_send_byte('/');                // Symbol table
  ax25_send_string(gps_aprs_lon);     // Lon: 000deg and 25.80 min
  ax25_send_byte('O');                // Symbol: O=balloon, -=QTH
  snprintf(temp, 4, "%03d", (int)(gps_course + 0.5)); 
  ax25_send_string(temp);             // Course (degrees)
  ax25_send_byte('/');                // and
  snprintf(temp, 4, "%03d", (int)(gps_speed + 0.5));
  ax25_send_string(temp);             // speed (knots)
  ax25_send_string("/A=");            // Altitude (feet). Goes anywhere in the comment area
  snprintf(temp, 7, "%06ld", (long)(meters_to_feet(gps_altitude) + 0.5));
  ax25_send_string(temp);
  //ax25_send_string("/Ti=");
  //snprintf(temp, 6, "%d", sensors_int_lm60());
  //ax25_send_string(temp);
  //ax25_send_string("/Te=");
  //snprintf(temp, 6, "%d", sensors_ext_lm60());
  //ax25_send_string(temp);

  //Update: Use DS18B20 temperature sensors
  sensors.requestTemperatures(); 

  //temperature
  float temperatureA_c = sensors.getTempCByIndex(0);
  float temperatureB_c = sensors.getTempCByIndex(1);

  char comma[2] = ",";
  
  uint8_t minWidth = 9;
  uint8_t precision = 5;
  
  char str_temperatureA_c[8];
  minWidth = 4;
  precision = 2;
  dtostrf(temperatureA_c,minWidth,precision,str_temperatureA_c);
  ax25_send_string("/TA=");
  ax25_send_string(str_temperatureA_c);
  
  char str_temperatureB_c[8];
  minWidth = 4;
  precision = 2;
  dtostrf(temperatureB_c,minWidth,precision,str_temperatureB_c);
  ax25_send_string("/TB=");
  ax25_send_string(str_temperatureB_c);
  
  ax25_send_string("/V=");
  snprintf(temp, 6, "%d", sensors_vin());
  ax25_send_string(temp);
  ax25_send_byte(' ');
  ax25_send_string(APRS_COMMENT);     // Comment
  ax25_send_footer();

  ax25_flush_frame();                 // Tell the modem to go
}
