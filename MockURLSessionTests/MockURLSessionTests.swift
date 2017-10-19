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
        func normalize(url: URL) -> URL {
            return (URLComponents(url: url, resolvingAgainstBaseURL: true)?.url)!
        }
    }
    let endpoint = URL(string: "https://example.com/foo/bar")!
    let sampleData = "Foo 123".data(using: .utf8)!
    var subject: MockURLSession!
    
    override func setUp() {
        super.setUp()
        subject = MockURLSession()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSharedSession() {
        XCTAssertEqual(MockURLSession.sharedInstance, MockURLSession.sharedInstance)
    }
    
    func testTarget() {
        subject.registerMockResponse(endpoint, data: sampleData)
        XCTAssertNil(subject.resumedResponse(endpoint))
        subject.dataTask(with: endpoint) { (data: Data?, response: URLResponse?, error: Error?) in
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
        subject.dataTask(with: endpoint) { (data: Data?, response: URLResponse?, error: Error?) in
            XCTAssertNil(data)
            XCTAssertNil(response)
            XCTAssertEqual(MockURLSession.MockError.Code.NoResponseRegistered.rawValue, ((error as NSError?)?.code))
        }.resume()
    }
    
}
