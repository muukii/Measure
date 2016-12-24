# Measure

[![CI Status](http://img.shields.io/travis/muukii/Measure.svg?style=flat)](https://travis-ci.org/muukii/Measure)
[![Version](https://img.shields.io/cocoapods/v/Measure.svg?style=flat)](http://cocoapods.org/pods/Measure)
[![License](https://img.shields.io/cocoapods/l/Measure.svg?style=flat)](http://cocoapods.org/pods/Measure)
[![Platform](https://img.shields.io/cocoapods/p/Measure.svg?style=flat)](http://cocoapods.org/pods/Measure)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`Measure` is **Performance measurement tool**

## Example

```swift
// set name, threshold (NSTimeInterval)
var measure = Measure(name: "name of operation", threshold: 1 / 60)
measure.start()

// Run the process to be measured.

measure.end()
```

## Requirements

## Installation

Measure is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Measure"
```

## Author

muukii, m@muukii.me

## License

Measure is available under the MIT license. See the LICENSE file for more info.
