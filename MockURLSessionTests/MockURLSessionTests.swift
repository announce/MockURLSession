//
//  MockURLSessionTests.swift
//  MockURLSessionTests
//
//  Created by YAMAMOTOKenta on 8/24/16.
//  Copyright © 2016 ymkjp. All rights reserved.
//

import XCTest
@testable import MockURLSession

class MockURLSessionTests: XCTestCase {
    class CustomNormalizer: MockURLSessionNormalizer {
        func normalizeUrl(url: NSURL) -> NSURL {
            return (NSURLComponents(URL: url, resolvingAgainstBaseURL: true)?.URL)!
        }
    }
    let endpoint = NSURL(string: "https://example.com/foo/bar")!
    let sampleData = "Foo 123".dataUsingEncoding(NSUTF8StringEncoding)!
    var subject: MockURLSession!
    
    override func setUp() {
        super.setUp()
        subject = MockURLSession()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSharedSession() {
        XCTAssertEqual(MockURLSession.sharedSession(), MockURLSession.sharedSession())
    }
    
    func testTarget() {
        subject.registerMockResponse(endpoint, data: sampleData)
        XCTAssertNil(subject.resumedResponse(endpoint))
        subject.dataTaskWithURL(endpoint) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            XCTAssertEqual(self.sampleData, data)
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            XCTAssertNotNil(self.subject.resumedResponse(self.endpoint))
        }.resume()
    }
    
    func testDefault() {
        XCTAssertTrue(subject.normalizer is MockURLSession.DefaultNormalizer)
    }
    
    func testNormalizer() {
        subject.normalizer = CustomNormalizer()
        testTarget()
        XCTAssertTrue(subject.normalizer is CustomNormalizer)
    }
    
    func testNoResponseRegistered() {
        subject.dataTaskWithURL(endpoint) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            XCTAssertNil(data)
            XCTAssertNil(response)
            XCTAssertEqual(MockURLSession.Error.Code.NoResponseRegistered.rawValue, error?.code)
        }.resume()
    }
    
}
