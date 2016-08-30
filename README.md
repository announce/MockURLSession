MockURLSession
===

[![Build Status](https://travis-ci.org/announce/MockURLSession.svg?branch=master)](https://travis-ci.org/announce/MockURLSession)
[![CocoaPods](https://img.shields.io/cocoapods/v/MockURLSession.svg)](https://cocoapods.org/pods/MockURLSession)

Are you a dependency injection devotee? Let's mock `NSURLSession` together.


## Features

* No need to modify production code to mock `NSURLSession`
* Customizable URL matching logic to mock responses
* Testable that the mocked responses are surely called


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
Note that this requires CocoaPods version 36, and your iOS deployment target to be at least 8.0.


## Usage

#### Quick glance

Let's take a case to test `MyApp` below.

```swift
class MyApp {
    static let apiUrl = NSURL(string: "https://example.com/foo/bar")!
    let session: NSURLSession
    var data: NSData?
    var error: NSError?
    init(session: NSURLSession = NSURLSession.sharedSession()) {
        self.session = session
    }
    func doSomething() {
        session.dataTaskWithURL(MyApp.apiUrl) { (data, _, error) in
            self.data = data
            self.error = error
        }.resume()
    }
}
```

In the test code,

```swift
import MockURLSession
```

and write testing by any flamewrorks you prefer sush as XCTest (Written by `print` here).

```swift
// Initialization
let session = MockURLSession()
// Or, use shared instance as `NSURLSession` provides
MockURLSession.sharedSession()

// Setup a mock response
let data = "Foo 123".dataUsingEncoding(NSUTF8StringEncoding)!
session.registerMockResponse(MyApp.apiUrl, data:data)

// Inject the session to the target app code and the response will be mocked like below
let app = MyApp(session: session)
app.doSomething()

print(NSString(data:app.data!, encoding:NSUTF8StringEncoding)!)  // Foo 123
print(app.error)    // nil

// Make sure that the data task is resumed in the app code
print(session.resumedResponse(MyApp.apiUrl) != nil)  // true
```

#### URL matching customization

```swift
// Customize URL matching logic if you prefer
class Normalizer: MockURLSessionNormalizer {
    func normalizeUrl(url: NSURL) -> NSURL {
        // Fuzzy matching example
        let components = NSURLComponents()
        components.host = url.host
        components.path = url.path
        return components.URL!
    }
}
// Note that you should setup the normalizer before registering mocked response
let data = NSKeyedArchiver.archivedDataWithRootObject(["username": "abc", "age": 20])
let session = MockURLSession()
session.normalizer = Normalizer()
session.registerMockResponse(MyApp.apiUrl, data:data)
```

## Disclosure

#### Inspirations

* This module is inspired from the entry [*Mocking Classes You Don't Own · Masilotti\.com*](http://masilotti.com/testing-nsurlsession-input/#comment-2493597339) and its comments.


## Development tips

#### A long way to bump up spec version
1. Xcode: MockURLSession > Identity > Version
1. Pod: `s.version` in *MockURLSession.podspec*
1. Git: `git tag 1.0.0 && git push origin --tag`
1. Release by `pod trunk push MockURLSession.podspec`
