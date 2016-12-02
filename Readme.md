![](header.png)

[![Travis](https://img.shields.io/travis/Comyar Zaheri/Jupiter/master.svg)](https://travis-ci.org/comyar/Jupiter/branches)
[![Platforms](https://img.shields.io/cocoapods/p/Jupiter.svg)](https://cocoapods.org/pods/Jupiter)
[![License](https://img.shields.io/cocoapods/l/Jupiter.svg)](https://raw.githubusercontent.com/Comyar Zaheri/Jupiter/master/LICENSE)

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Jupiter.svg)](https://cocoapods.org/pods/Jupiter)



- [Requirements](#requirements)
- [Usage](#usage)
- [Installation](#installation)
- [License](#license)

## Requirements

- iOS 10.0+ / Mac OS X 10.12+ / tvOS 10.0+ / watchOS 2.0+
- Xcode 8.0+

## Usage

Supported Weather APIs:

- [Dark Sky](https://darksky.net/dev/) ([WIP](https://github.com/comyar/Jupiter/issues/1) historical data support)

### Dark Sky

#### [Forecast Request](https://darksky.net/dev/docs/forecast)

A default ```Request.send``` function is provided that simply uses the shared ```URLSession``` in your app:

```swift
let api = DarkSkyAPI(key: "<API_KEY>")
api.forecast(latitude: 47.6062, longitude: -122.3321).send { result -> Void in
  switch result {
  case .success(let response):
    // The response here is queryable for any key available in the docs except for "flags", which was not ported
    print(response)
  case .error(let error):
    print(error)
  }
}
```

However if you'd like to use your own networking stack, you can simply create a ```DarkSkyForecastRequest``` and use the generated URL directly:

```swift
let api = DarkSkyAPI(key: "<API_KEY>")
let request = api.forecast(latitude: 47.6062, longitude: -122.3321)

/// Creating without the convenience API also works:
/// let request =  DarkSkyForecastRequest(key: "<API_KEY>", latitude: 47.6062, longitude: -122.3321)

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
let response = request.toResponse(data: data)
```

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

pod 'Jupiter', '~> 0.0.1'
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
github "Jupiter/Jupiter" ~> 0.0.1
```
### Swift Package Manager

To use Jupiter as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following in your Package.swift file.

``` swift
import PackageDescription

let package = Package(
    name: "HelloJupiter",
    dependencies: [
        .Package(url: "https://github.com/Comyar Zaheri/Jupiter.git", "0.0.1")
    ]
)
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate Jupiter into your project manually.

#### Git Submodules

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add Jupiter as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/comyar/Jupiter.git
$ git submodule update --init --recursive
```

- Open the new `Jupiter` folder, and drag the `Jupiter.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `Jupiter.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `Jupiter.xcodeproj` folders each with two different versions of the `Jupiter.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from.

- Select the `Jupiter.framework`.

- And that's it!

> The `Jupiter.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

#### Embeded Binaries

- Download the latest release from https://github.com/Comyar Zaheri/Jupiter/releases
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- Add the downloaded `Jupiter.framework`.
- And that's it!

## License

Jupiter is released under the MIT license. See [LICENSE](https://github.com/comyar/Jupiter/blob/master/LICENSE) for details.
