MockURLSession
===

[![Build Status](https://travis-ci.org/announce/MockURLSession.svg?branch=master)](https://travis-ci.org/announce/MockURLSession)
[![CocoaPods](https://img.shields.io/cocoapods/v/MockURLSession.svg?maxAge=2592000)](https://cocoapods.org/pods/MockURLSession)


## Installation

#### CocoaPods (iOS 8+, OS X 10.9+)

You can use [Cocoapods](http://cocoapods.org/) to install `MockURLSession` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyAppTest' do
	pod 'MockURLSession'
end
```
Note that this requires CocoaPods version 36, and your iOS deployment target to be at least 8.0:


## Usage

```swift
import MockURLSession

// Initialization
let session = MockURLSession()
// Or, use shared instance
MockURLSession.sharedSession()

// Setup a mock response
let endpointUrl = NSURL(string: "https://example.com/foo/bar")!
let sampleData = "Foo 123".dataUsingEncoding(NSUTF8StringEncoding)!
session.registerMockResponse(endpointUrl, data:sampleData)

// Arbitrary processes in your app code
session.dataTaskWithURL(endpointUrl) { (data: NSData?, _: NSURLResponse?, error: NSError?) in
    print(data === sampleData)  // true
    print(error === nil)  // true
}.resume()
```
