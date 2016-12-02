//: Playground - noun: a place where people can play

import PlaygroundSupport
import WeatherKit

/// Set this to true
PlaygroundPage.current.needsIndefiniteExecution = false

let key = "<YOUR_API_KEY_HERE>"
let api = DarkSkyAPI(key: key)

api.forecast(latitude: 47.6062, longitude: -122.3321)
   .send { result -> Void in
  switch result {
  case .success(let response):
    print("The current temperature in \(response.currently!.temperature!)")
  case .error(let error):
    print(error)
  }
}