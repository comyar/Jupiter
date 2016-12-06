//
//  DarkSkyAPI.swift
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
  
  public static func toResponse(data: Data) throws -> DarkSkyForecastResponse {
    return try unbox(data: data)
  }
  
  public func send(handler: @escaping (Result<DarkSkyForecastResponse>) -> (Void)) {
    URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, err) -> Void in
      if let error = err {
        handler(.error(error))
      } else {
        do {
          handler(.success(try DarkSkyForecastRequest.toResponse(data: data!)))
        } catch {
          handler(.error(error))
        }
      }
    }).resume()
  }
}


// MARK:- DarkSkyForecastResponse

public class DarkSkyForecastResponse: NSObject, NSCoding, Unboxable {
  
  public let latitude: Double?
  public let longitude: Double?
  public let timezone: String?
  public let currently: DarkSkyDataPoint?
  public let minutely : DarkSkyDataBlock?
  public let hourly: DarkSkyDataBlock?
  public let daily: DarkSkyDataBlock?
  public let alerts: [DarkSkyAlert]?
  
  // MARK: NSCoding
  
  public required init(coder aDecoder: NSCoder) {
    latitude = aDecoder.decodeObject(forKey:"latitude") as? Double
    longitude = aDecoder.decodeObject(forKey:"longitude") as? Double
    timezone = aDecoder.decodeObject(forKey:"timezone") as? String
    currently = aDecoder.decodeObject(forKey:"currently") as? DarkSkyDataPoint
    minutely = aDecoder.decodeObject(forKey:"minutely") as? DarkSkyDataBlock
    hourly = aDecoder.decodeObject(forKey:"hourly") as? DarkSkyDataBlock
    daily = aDecoder.decodeObject(forKey:"daily") as? DarkSkyDataBlock
    alerts = aDecoder.decodeObject(forKey:"alerts") as? [DarkSkyAlert]
  }
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(latitude, forKey:"latitude")
    aCoder.encode(longitude, forKey:"longitude")
    aCoder.encode(timezone, forKey:"timezone")
    aCoder.encode(currently, forKey:"currently")
    aCoder.encode(minutely, forKey:"minutely")
    aCoder.encode(hourly, forKey:"hourly")
    aCoder.encode(daily, forKey:"daily")
    aCoder.encode(alerts, forKey:"alerts")
  }
  
  // MARK: NSObject
  
  public override func isEqual(_ object: Any?) -> Bool {
    if let rhs = object as? DarkSkyForecastResponse {
      return latitude ==? rhs.latitude &&
        longitude ==? rhs.longitude &&
        timezone ==? rhs.timezone &&
        currently ==? rhs.currently &&
        minutely ==? rhs.minutely &&
        hourly ==? rhs.hourly &&
        daily ==? rhs.daily &&
        alerts ==? rhs.alerts
    }
    return false
  }
  
  // MARK: Unboxable
  
  public required init(unboxer: Unboxer) throws {
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


// MARK:- DarkSkyDataBlock

public class DarkSkyDataBlock: NSObject, NSCoding, Unboxable {
  
  public let summary: String?
  public let icon: Climacon?
  public let data: [DarkSkyDataPoint]?
  
  
  // MARK: NSCoding
  
  public required init(coder aDecoder: NSCoder) {
    summary = aDecoder.decodeObject(forKey: "summary") as? String
    icon = Climacon(rawValue: aDecoder.decodeObject(forKey:"icon") as? String ?? "")
    data = aDecoder.decodeObject(forKey: "data") as? [DarkSkyDataPoint]
  }
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(summary, forKey: "summary")
    aCoder.encode(icon?.rawValue, forKey: "icon")
    aCoder.encode(data, forKey: "data")
  }
  
  // MARK: NSObject
  
  public override func isEqual(_ object: Any?) -> Bool {
    if let rhs = object as? DarkSkyDataBlock {
      return summary ==? rhs.summary &&
        icon ==? rhs.icon &&
        data ==? rhs.data
    }
    return false
  }
  
  // MARK: Unboxable
  
  public required init(unboxer: Unboxer) throws {
    summary = unboxer.unbox(key: "summary")
    icon = unboxer.unbox(key: "icon")
    data = unboxer.unbox(key: "data")
  }
}


// MARK:- DarkSkyDataPoint

public class DarkSkyDataPoint: NSObject, NSCoding, Unboxable {
  
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
  
  // MARK: NSCoding
  
  public required init(coder aDecoder: NSCoder) {
    time = aDecoder.decodeDouble(forKey:"time")
    summary = aDecoder.decodeObject(forKey:"summary") as? String
    icon = Climacon(rawValue: aDecoder.decodeObject(forKey:"icon") as? String ?? "")
    sunriseTime = aDecoder.decodeObject(forKey:"sunriseTime") as? TimeInterval
    sunsetTime = aDecoder.decodeObject(forKey:"sunsetTime") as? TimeInterval
    moonPhase = aDecoder.decodeObject(forKey:"moonPhase") as? Double
    nearestStormDistance = aDecoder.decodeObject(forKey:"nearestStormDistance") as? Double
    precipIntensity = aDecoder.decodeObject(forKey:"precipIntensity") as? Double
    precipIntensityError = aDecoder.decodeObject(forKey:"precipIntensityError") as? Double
    precipProbability = aDecoder.decodeObject(forKey:"precipProbability") as? Double
    precipIntensityMax = aDecoder.decodeObject(forKey:"precipIntensityMax") as? Double
    precipIntensityMaxTime = aDecoder.decodeObject(forKey:"precipIntensityMaxTime") as? TimeInterval
    precipType = aDecoder.decodeObject(forKey:"precipType") as? String
    temperature = aDecoder.decodeObject(forKey:"temperature") as? Double
    temperatureMin = aDecoder.decodeObject(forKey:"temperatureMin") as? Double
    temperatureMinTime = aDecoder.decodeObject(forKey:"temperatureMinTime") as? TimeInterval
    temperatureMax = aDecoder.decodeObject(forKey:"temperatureMax") as? Double
    temperatureMaxTime = aDecoder.decodeObject(forKey:"temperatureMaxTime") as? TimeInterval
    apparentTemperature = aDecoder.decodeObject(forKey:"apparentTemperature") as? Double
    apparentTemperatureMin = aDecoder.decodeObject(forKey:"apparentTemperatureMin") as? Double
    apparentTemperatureMinTime = aDecoder.decodeObject(forKey:"apparentTemperatureMinTime") as? TimeInterval
    apparentTemperatureMax = aDecoder.decodeObject(forKey:"apparentTemperatureMax") as? Double
    apparentTemperatureMaxTime = aDecoder.decodeObject(forKey:"apparentTemperatureMaxTime") as? TimeInterval
    dewPoint = aDecoder.decodeObject(forKey:"dewPoint") as? Double
    humidity = aDecoder.decodeObject(forKey:"humidity") as? Double
    windSpeed = aDecoder.decodeObject(forKey:"windSpeed") as? Double
    windBearing = aDecoder.decodeObject(forKey:"windBearing") as? Double
    visibility = aDecoder.decodeObject(forKey:"visibility") as? Double
    cloudCover = aDecoder.decodeObject(forKey:"cloudCover") as? Double
    pressure = aDecoder.decodeObject(forKey:"pressure") as? Double
    ozone = aDecoder.decodeObject(forKey:"ozone") as? Double
  }
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(time, forKey:"time")
    aCoder.encode(summary, forKey:"summary")
    aCoder.encode(icon?.rawValue, forKey:"icon")
    aCoder.encode(sunriseTime, forKey:"sunriseTime")
    aCoder.encode(sunsetTime, forKey:"sunsetTime")
    aCoder.encode(moonPhase, forKey:"moonPhase")
    aCoder.encode(nearestStormDistance, forKey:"nearestStormDistance")
    aCoder.encode(precipIntensity, forKey:"precipIntensity")
    aCoder.encode(precipIntensityError, forKey:"precipIntensityError")
    aCoder.encode(precipProbability, forKey:"precipProbability")
    aCoder.encode(precipIntensityMax, forKey:"precipIntensityMax")
    aCoder.encode(precipIntensityMaxTime, forKey:"precipIntensityMaxTime")
    aCoder.encode(precipType, forKey:"precipType")
    aCoder.encode(temperature, forKey:"temperature")
    aCoder.encode(temperatureMin, forKey:"temperatureMin")
    aCoder.encode(temperatureMinTime, forKey:"temperatureMinTime")
    aCoder.encode(temperatureMax, forKey:"temperatureMax")
    aCoder.encode(temperatureMaxTime, forKey:"temperatureMaxTime")
    aCoder.encode(apparentTemperature, forKey:"apparentTemperature")
    aCoder.encode(apparentTemperatureMin, forKey:"apparentTemperatureMin")
    aCoder.encode(apparentTemperatureMinTime, forKey:"apparentTemperatureMinTime")
    aCoder.encode(apparentTemperatureMax, forKey:"apparentTemperatureMax")
    aCoder.encode(apparentTemperatureMaxTime, forKey:"apparentTemperatureMaxTime")
    aCoder.encode(dewPoint, forKey:"dewPoint")
    aCoder.encode(humidity, forKey:"humidity")
    aCoder.encode(windSpeed, forKey:"windSpeed")
    aCoder.encode(windBearing, forKey:"windBearing")
    aCoder.encode(visibility, forKey:"visibility")
    aCoder.encode(cloudCover, forKey:"cloudCover")
    aCoder.encode(pressure, forKey:"pressure")
    aCoder.encode(ozone, forKey:"ozone")
  }
  
  // MARK: NSObject
  
  public override func isEqual(_ object: Any?) -> Bool {
    if let rhs = object as? DarkSkyDataPoint {
      return time ==? rhs.time &&
        summary ==? rhs.summary &&
        icon ==? rhs.icon &&
        sunriseTime ==? rhs.sunriseTime &&
        sunsetTime ==? rhs.sunsetTime &&
        moonPhase ==? rhs.moonPhase &&
        nearestStormDistance ==? rhs.nearestStormDistance &&
        precipIntensity ==? rhs.precipIntensity &&
        precipIntensityError ==? rhs.precipIntensityError &&
        precipProbability ==? rhs.precipProbability &&
        precipIntensityMax ==? rhs.precipIntensityMax &&
        precipIntensityMaxTime ==? rhs.precipIntensityMaxTime &&
        precipType ==? rhs.precipType &&
        temperature ==? rhs.temperature &&
        temperatureMin ==? rhs.temperatureMin &&
        temperatureMinTime ==? rhs.temperatureMinTime &&
        temperatureMax ==? rhs.temperatureMax &&
        temperatureMaxTime ==? rhs.temperatureMaxTime &&
        apparentTemperature ==? rhs.apparentTemperature &&
        apparentTemperatureMin ==? rhs.apparentTemperatureMin &&
        apparentTemperatureMinTime ==? rhs.apparentTemperatureMinTime &&
        apparentTemperatureMax ==? rhs.apparentTemperatureMax &&
        apparentTemperatureMaxTime ==? rhs.apparentTemperatureMaxTime &&
        dewPoint ==? rhs.dewPoint &&
        humidity ==? rhs.humidity &&
        windSpeed ==? rhs.windSpeed &&
        windBearing ==? rhs.windBearing &&
        visibility ==? rhs.visibility &&
        cloudCover ==? rhs.cloudCover &&
        pressure ==? rhs.pressure &&
        ozone ==? rhs.ozone
    }
    return false
  }
  
  // MARK: Unboxable
  
  public required init(unboxer: Unboxer) throws {
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


// MARK:- DarkSkyAlert

public class DarkSkyAlert: NSObject, NSCoding, Unboxable {
  
  public let title: String
  public let summary: String
  public let expires: TimeInterval
  public let uri: URL
  
  
  // MARK: NSCoding
  public required init(coder aDecoder: NSCoder) {
    title = aDecoder.decodeObject(forKey:"title") as! String
    summary = aDecoder.decodeObject(forKey:"summary") as! String
    expires = aDecoder.decodeDouble(forKey:"expires")
    uri = aDecoder.decodeObject(forKey:"uri") as! URL
  }
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(title, forKey:"title")
    aCoder.encode(summary, forKey:"summary")
    aCoder.encode(expires, forKey:"expires")
    aCoder.encode(uri, forKey:"uri")
  }
  
  // MARK: NSObject
  
  public override func isEqual(_ object: Any?) -> Bool {
    if let rhs = object as? DarkSkyAlert {
      return title ==? rhs.title &&
        summary ==? rhs.summary &&
        expires ==? rhs.expires &&
        uri ==? rhs.uri
    }
    return false
  }
  
  // MARK: Unboxable
  
  public required init(unboxer: Unboxer) throws {
    title = try unboxer.unbox(key: "title")
    summary = try unboxer.unbox(key: "description")
    expires = try unboxer.unbox(key: "expires")
    uri = try unboxer.unbox(key: "uri")
  }
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


// MARK:- Serialization

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
