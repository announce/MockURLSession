//
//  Example.swift
//  MockURLSession
//
//  Created by YAMAMOTOKenta on 8/25/16.
//  Copyright © 2016 ymkjp. All rights reserved.
//

import XCTest
@testable import MockURLSession


class Example: XCTestCase {

    class MyApp {
        static let apiUrl = URL(string: "https://example.com/foo/bar")!
        let session: URLSession
        var data: Data?
        var error: Error?
        init(session: URLSession = URLSession.shared) {
            self.session = session
        }
        func doSomething() {
            session.dataTask(with: MyApp.apiUrl) { (data, _, error) in
                self.data = data
                self.error = error
            }.resume()
        }
    }
    
    func testQuickGlance() {
        // Initialization
        let session = MockURLSession()
//         Or, use shared instance as `URLSession` provides
//        MockURLSession.sharedInstance
        
        // Setup a mock response
        let data = "Foo 123".data(using: .utf8)!
        session.registerMockResponse(MyApp.apiUrl, data: data)
        
        // Inject the session to the target app code and the response will be mocked like below
        let app = MyApp(session: session)
        app.doSomething()
        
        print(String(data:app.data!, encoding: .utf8)!)  // Foo 123
        print(app.error as Any)    // nil
        
        // Make sure that the data task is resumed in the app code
        print(session.resumedResponse(MyApp.apiUrl) != nil)  // true
    }
    
    func testUrlCustomization() {
        // Customize URL matching logic if you prefer
        class Normalizer: MockURLSessionNormalizer {
            func normalize(url: URL) -> URL {
                // Fuzzy matching example
                var components = URLComponents()
                components.host = url.host
                components.path = url.path
                return components.url!
            }
        }
        // Note that you should setup the normalizer before registering mocked response
        let data = NSKeyedArchiver.archivedData(withRootObject: ["username": "abc", "age": 20])
        let session = MockURLSession()
        session.normalizer = Normalizer()
        session.registerMockResponse(MyApp.apiUrl, data: data)
    }
    
}
