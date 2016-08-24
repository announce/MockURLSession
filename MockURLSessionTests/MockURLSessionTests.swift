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
    let fixture = Fixture.read("sample_data")
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
        subject.setupMockResponse(endpoint, data: fixture)
        subject.dataTaskWithURL(endpoint) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            XCTAssertEqual(self.fixture, data)
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
}
