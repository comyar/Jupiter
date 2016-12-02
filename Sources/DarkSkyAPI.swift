//
//  DarkSkyAPI.swift
//  WeatherKit
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


/**
 Implementation of the Dark Sky API
 
 Documentation for the API can be found on the Dark Sky website:
 https://darksky.net/dev/docs
 */

// MARK:- Imports

import Unbox


// MARK:- DarkSkyAPI

public struct DarkSkyAPI {
  
  private let key: String
  
  public init(key: String) {
    self.key = key
  }
  
  public func forecast(latitude: Double, longitude: Double) -> DarkSkyForecastRequest {
    return DarkSkyForecastRequest(key: key, latitude: latitude, longitude: longitude)
  }
}


// MARK:- DarkSkyRequest

public protocol DarkSkyRequest: Request {}
public extension DarkSkyRequest {
  var scheme: String {
    return "https"
  }
  var host: String {
    return "api.darksky.net"
  }
}


// MARK:- DarkSkyForecastRequest

public struct DarkSkyForecastRequest: DarkSkyRequest {
  
  public typealias Response = DarkSkyForecastResponse
  
  public var lang: DarkSkyLang = .english
  public var units: DarkSkyUnits = .us
  public var exclude: [DarkSkyResponseType] = []
  
  public var url: URL? {
    var components = URLComponents()
    components.scheme = scheme
    components.host = host
    components.path = "/forecast/" + key + "/" + "\(latitude)" + "," + "\(longitude)"
    var queryItems = [
      URLQueryItem(name: "lang", value: lang.rawValue),
      URLQueryItem(name: "units", value: units.rawValue)
    ]
    
    if exclude.count > 0 {
      queryItems.append(URLQueryItem(name: "exclude", value: exclude.reduce("", { (result, type) -> String in
        result + "," + type.rawValue
      })))
    }
    
    components.queryItems = queryItems
    
    return components.url
  }
  
  public let key: String
  public let latitude: Double
  public let longitude: Double
  
  public init(key: String, latitude: Double, longitude: Double) {
    self.key = key
    self.latitude = latitude
    self.longitude = longitude
  }
  
  public func toResponse(data: Data) throws -> DarkSkyForecastResponse {
    return try unbox(data: data)
  }
  
  public func send(handler: @escaping (Result<DarkSkyForecastResponse>) -> (Void)) {
    URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, err) -> Void in
      if let error = err {
        handler(.error(error))
      } else {
        do {
          handler(.success(try self.toResponse(data: data!)))
        } catch {
          handler(.error(error))
        }
      }
    }).resume()
  }
}


// MARK:- DarkSkyForecastResponse

public struct DarkSkyForecastResponse {
  public let latitude: Double?
  public let longitude: Double?
  public let timezone: String?
  public let currently: DarkSkyDataPoint?
  public let minutely : DarkSkyDataBlock?
  public let hourly: DarkSkyDataBlock?
  public let daily: DarkSkyDataBlock?
  public let alerts: [DarkSkyAlert]?
}


// MARK:- DarkSkyDataBlock

public struct DarkSkyDataBlock {
  public let summary: String?
  public let icon: Climacon?
  public let data: [DarkSkyDataPoint]?
}


// MARK:- DarkSkyDataPoint

public struct DarkSkyDataPoint {
  public let time: TimeInterval
  public let summary: String?
  public let icon: Climacon?
  public let sunriseTime: TimeInterval?
  public let sunsetTime: TimeInterval?
  public let moonPhase: Double?
  public let nearestStormDistance: Double?
  public let precipIntensity: Double?
  public let precipIntensityError: Double?
  public let precipProbability: Double?
  public let precipIntensityMax: Double?
  public let precipIntensityMaxTime: TimeInterval?
  public let precipType: String?
  public let temperature: Double?
  public let temperatureMin: Double?
  public let temperatureMinTime: TimeInterval?
  public let temperatureMax: Double?
  public let temperatureMaxTime: TimeInterval?
  public let apparentTemperature: Double?
  public let apparentTemperatureMin: Double?
  public let apparentTemperatureMinTime: TimeInterval?
  public let apparentTemperatureMax: Double?
  public let apparentTemperatureMaxTime: TimeInterval?
  public let dewPoint: Double?
  public let humidity: Double?
  public let windSpeed: Double?
  public let windBearing: Double?
  public let visibility: Double?
  public let cloudCover: Double?
  public let pressure: Double?
  public let ozone: Double?
}


// MARK:- DarkSkyAlert

public struct DarkSkyAlert {
  let title: String
  let description: String
  let expires: TimeInterval
  let uri: URL
}


// MARK:- Configuration

// MARK: DarkSkyLang

public enum DarkSkyLang: String {
  case arabic = "ar"
  case azerbaijani = "az"
  case belarusian = "be"
  case bosnian = "bs"
  case catalan = "ca"
  case czech = "cs"
  case german = "de"
  case greek = "el"
  case english = "en"
  case spanish = "es"
  case estonian = "et"
  case french = "fr"
  case croatian = "hr"
  case hungarian = "hu"
  case indonesian = "id"
  case italian = "it"
  case icelandic = "is"
  case cornish = "kw"
  case norwegian = "nb"
  case dutch = "nl"
  case polish = "pl"
  case portuguese = "pt"
  case russian = "ru"
  case slovak = "sk"
  case slovenian = "sl"
  case serbian = "sr"
  case swedish = "sv"
  case tetum = "tet"
  case turkish = "tr"
  case ukrainian = "uk"
  case igpayAtinlay = "x-pig-latin"
  case simplifiedChinese = "zh"
  case traditionalChinese = "zh-tw"
}

// MARK: DarkSkyUnits

public enum DarkSkyUnits: String {
  case auto = "auto"
  case ca = "ca"
  case uk2 = "uk2"
  case us = "us"
  case si = "si"
}

// MARK: DarkSkyResponseType

public enum DarkSkyResponseType: String {
  case currently = "currently"
  case minutely = "minutely"
  case hourly = "hourly"
  case daily = "daily"
  case alerts = "alerts"
}


// MARK:- Deserialization

// MARK: Climacon

private let icons: [String:Climacon] = [
  "clear-day" : .sun,
  "clear-night" : .moon,
  "rain" : .rain,
  "snow" : .snow,
  "sleet" : .sleet,
  "wind" : .wind,
  "fog" : .haze,
  "cloudy" : .cloud,
  "partly-cloudy-day" : .cloudSun,
  "partly-cloudy-night" : .cloudMoon
]

extension Climacon: UnboxableByTransform {
  public typealias UnboxRawValue = String
  public static func transform(unboxedValue: String) -> Climacon? {
    return icons[unboxedValue] ?? .sun
  }
}


// MARK: DarkSkyAlert

extension DarkSkyAlert: Unboxable {
  public init(unboxer: Unboxer) throws {
    title = try unboxer.unbox(key: "title")
    description = try unboxer.unbox(key: "description")
    expires = try unboxer.unbox(key: "expires")
    uri = try unboxer.unbox(key: "uri")
  }
}

// MARK: DarkSkyDataBlock

extension DarkSkyDataBlock: Unboxable {
  public init(unboxer: Unboxer) throws {
    summary = unboxer.unbox(key: "summary")
    icon = unboxer.unbox(key: "icon")
    data = unboxer.unbox(key: "data")
  }
}


// MARK: DarkSkyDataPoint

extension DarkSkyDataPoint: Unboxable {
  public init(unboxer: Unboxer) throws {
    time = try unboxer.unbox(key: "time")
    summary = unboxer.unbox(key: "summary")
    icon = unboxer.unbox(key: "icon")
    sunriseTime = unboxer.unbox(key: "sunriseTime")
    sunsetTime = unboxer.unbox(key: "sunsetTime")
    moonPhase = unboxer.unbox(key: "moonPhase")
    nearestStormDistance = unboxer.unbox(key: "nearestStormDistance")
    precipIntensity = unboxer.unbox(key: "precipIntensity")
    precipIntensityError = unboxer.unbox(key: "precipIntensityError")
    precipProbability = unboxer.unbox(key: "precipProbability")
    precipIntensityMax = unboxer.unbox(key: "precipIntensityMax")
    precipIntensityMaxTime = unboxer.unbox(key: "precipIntensityMaxTime")
    precipType = unboxer.unbox(key: "precipType")
    temperature = unboxer.unbox(key: "temperature")
    temperatureMin = unboxer.unbox(key: "temperatureMin")
    temperatureMinTime = unboxer.unbox(key: "temperatureMinTime")
    temperatureMax = unboxer.unbox(key: "temperatureMax")
    temperatureMaxTime = unboxer.unbox(key: "temperatureMaxTime")
    apparentTemperature = unboxer.unbox(key: "apparentTemperature")
    apparentTemperatureMin = unboxer.unbox(key: "apparentTemperatureMin")
    apparentTemperatureMinTime = unboxer.unbox(key: "apparentTemperatureMinTime")
    apparentTemperatureMax = unboxer.unbox(key: "apparentTemperatureMax")
    apparentTemperatureMaxTime = unboxer.unbox(key: "apparentTemperatureMaxTime")
    dewPoint = unboxer.unbox(key: "dewPoint")
    humidity = unboxer.unbox(key: "humidity")
    windSpeed = unboxer.unbox(key: "windSpeed")
    windBearing = unboxer.unbox(key: "windBearing")
    visibility = unboxer.unbox(key: "visibility")
    cloudCover = unboxer.unbox(key: "cloudCover")
    pressure = unboxer.unbox(key: "pressure")
    ozone = unboxer.unbox(key: "ozone")
  }
}

// MARK: DarkSkyForecastResponse

extension DarkSkyForecastResponse: Unboxable {
  public init(unboxer: Unboxer) throws {
    latitude = unboxer.unbox(key: "latitude")
    longitude = unboxer.unbox(key: "longitude")
    timezone = unboxer.unbox(key: "timezone")
    currently = unboxer.unbox(key: "currently")
    minutely = unboxer.unbox(key: "minutely")
    hourly = unboxer.unbox(key: "hourly")
    daily = unboxer.unbox(key: "daily")
    alerts = unboxer.unbox(key: "alerts")
  }
}
