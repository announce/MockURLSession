//
//  Example.swift
//  MockURLSession
//
//  Created by YAMAMOTOKenta on 8/25/16.
//  Copyright © 2016 ymkjp. All rights reserved.
//

import XCTest

class Example: XCTestCase {
    
    func test() {
        // Initialization
        let session = MockURLSession()
        // Or, use shared instance
        MockURLSession.sharedSession()
        
        // Setup a mock response
        let endpointUrl = NSURL(string: "https://example.com/foo/bar")!
        let sampleData = "Foo 123".dataUsingEncoding(NSUTF8StringEncoding)!
        session.registerMockResponse(endpointUrl, data:sampleData)
        
        session.dataTaskWithURL(endpointUrl) { (data: NSData?, _: NSURLResponse?, error: NSError?) in
            print(data === sampleData)  // true
            print(error === nil)  // true
        }.resume()
    }
    
}
