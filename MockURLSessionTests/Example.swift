//
//  Example.swift
//  MockURLSession
//
//  Created by YAMAMOTOKenta on 8/25/16.
//  Copyright © 2016 ymkjp. All rights reserved.
//

import XCTest

class Example: XCTestCase {

    class MyApp {
        static let apiUrl = NSURL(string: "https://example.com/foo/bar")!
        let session: NSURLSession
        var data: NSData?
        var error: NSError?
        init(session: NSURLSession = NSURLSession.sharedSession()) {
            self.session = session
        }
        func doSomething() {
            session.dataTaskWithURL(MyApp.apiUrl) { (data: NSData?, _: NSURLResponse?, error: NSError?) in
                self.data = data
                self.error = error
            }.resume()
        }
    }
    
    func testQuickGlance() {
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
    }
    
    func testUrlCustomization() {
        // Customize URL mathing logic if you prefer
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
    }
    
}
