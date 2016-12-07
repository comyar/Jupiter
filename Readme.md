![](header.png)

[![Platforms](https://img.shields.io/cocoapods/p/Jupiter.svg)](https://cocoapods.org/pods/Jupiter)
[![License](https://img.shields.io/cocoapods/l/Jupiter.svg)](https://raw.githubusercontent.com/Comyar Zaheri/Jupiter/master/LICENSE)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Jupiter.svg)](https://cocoapods.org/pods/Jupiter)

## Usage

Supported Weather APIs:

- [Dark Sky](https://darksky.net/dev/) ([WIP](https://github.com/comyar/Jupiter/issues/1) historical data support)

### Dark Sky

#### [Forecast Request](https://darksky.net/dev/docs/forecast)

A default ```Request.send``` function is provided that simply uses the shared ```URLSession``` in your app:

```swift
import Jupiter

let api = DarkSkyAPI(key: "<API_KEY>")
api.forecast(latitude: 47.6062, longitude: -122.3321).send { result -> Void in
  switch result {
  case .success(let response):
    // The response here is queryable for any key available in the docs except for "flags"
    print(response)
  case .error(let error):
    print(error)
  }
}
```

However if you'd like to use your own networking stack, you can simply create a ```DarkSkyForecastRequest``` and use the generated URL directly:

```swift
import Jupiter

let api = DarkSkyAPI(key: "<API_KEY>")
let request = api.forecast(latitude: 47.6062, longitude: -122.3321)

/// Creating without the convenience API also works:
/// let request = DarkSkyForecastRequest(key: "<API_KEY>", latitude: 47.6062, longitude: -122.3321)

/// Configure the request
request.excludes = [.minutely, .hourly]
request.lang = .russian
request.units = .si

/// Get the URL
let url: URL = request.url!

/// Pass URL to networking layer 

/// Get raw data from networking layer
let data: Data = ...

/// Parse data and bind to response object
let response = DarkSkyForecastRequest.toResponse(data: data)
```

## Climacons

Jupiter has first-class support for [Climacons](http://adamwhitcroft.com/climacons/), a beautiful set of pictographs designed by [Adam Whitcroft](http://adamwhitcroft.com/). All icon-related fields on response models will be bound to the [Climacon enum](https://github.com/comyar/Jupiter/blob/master/Sources/Climacon.swift) defined in Jupiter, whose raw values map directly to the [Climacons-Font](https://github.com/christiannaths/Climacons-Font) bundled by [Christian Naths](https://christiannaths.com/).

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build Jupiter 0.0.1+.

To integrate Jupiter into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

pod 'Jupiter', '~> 0.0.2'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Jupiter into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "comyar/Jupiter" ~> 0.0.2
```

## License

Jupiter is released under the MIT license. See [LICENSE](https://github.com/comyar/Jupiter/blob/master/LICENSE) for details.
