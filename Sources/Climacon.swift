//
//  Climacons.swift
//  Jupiter
//
//  MIT License
//
//  Copyright (c) 2016 Comyar Zaheri
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


// MARK:- Climacon

/**
 The name of the Climacons font.
 */
public let climaconFontName = "Climacons-Font"


/**
 Contains the mappings from icon to character for the Climacons font, bundled by
 Christian Naths.
 http://adamwhitcroft.com/climacons/font/
 https://github.com/christiannaths/Climacons-Font
 
 Climacons first created in icon form by Adam Whitcroft.
 http://adamwhitcroft.com/climacons/
 */
public enum Climacon: String {
  case unknown = "~"
  case cloud = "!"
  case cloudSun = "'"
  case cloudMoon = "#"
  case rain = "$"
  case rainSun = "%"
  case rainMoon = "&"
  case showers = "\""
  case showersSun = "("
  case showersMoon = ")"
  case downpour = "*"
  case downpourSun = "+"
  case downpourMoon = " "
  case drizzle = "-"
  case drizzleSun = "."
  case drizzleMoon = "/"
  case sleet = "0"
  case sleetSun = "1"
  case sleetMoon = "2"
  case hail = "3"
  case hailSun = "4"
  case hailMoon = "5"
  case flurries = "6"
  case flurriesSun = "7"
  case flurriesMoon = "8"
  case snow = "9"
  case snowSun = ":"
  case snowMoon = ";"
  case fog = "<"
  case fogSun = "="
  case fogMoon = ">"
  case haze = "?"
  case hazeSun = "@"
  case hazeMoon = "A"
  case wind = "B"
  case windcloud = "C"
  case windcloudSun = "D"
  case windcloudMoon = "E"
  case lightning = "F"
  case lightningSun = "G"
  case lightningMoon = "H"
  case sun = "I"
  case sunset = "J"
  case sunrise = "K"
  case sunLow = "L"
  case sunLower = "M"
  case moon = "N"
  case moonNew = "O"
  case moonWaxingCrescent = "P"
  case moonWaxingQuarter = "Q"
  case moonWaxingGibbous = "R"
  case moonFull = "S"
  case moonWaningGibbous = "T"
  case moonWaningQuarter = "U"
  case moonWaningCrescent = "V"
  case snowflake = "W"
  case tornado = "X"
  case thermometer = "Y"
  case thermometerLow = "Z"
  case thermometerMediumLow = "["
  case thermometerMediumHigh = "\\"
  case thermometerHigh = "]"
  case thermometerFull = "^"
  case celsius = "_"
  case fahrenheit = "`"
  case compass = "a"
  case compassNorth = "b"
  case compassEast = "c"
  case compassSouth = "d"
  case compassWest = "e"
  case umbrella = "f"
  case sunglasses = "g"
  case cloudRefresh = "h"
  case cloudUp = "i"
  case cloudDown = "j"
}
