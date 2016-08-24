//
//  MockURLSession.swift
//  MockURLSession
//
//  Created by YAMAMOTOKenta on 8/24/16.
//  Copyright © 2016 ymkjp. All rights reserved.
//

import Foundation

public protocol MockURLSessionNormalizer {
    // Normalize URL to match resources
    func normalizeUrl(url: NSURL) -> NSURL
}

public class MockURLSession: NSURLSession {
    public typealias CompletionHandler = (NSData?, NSURLResponse?, NSError?) -> Void
    public typealias Response = (data: NSData?, urlResponse: NSURLResponse?, error: NSError?)
    public typealias HttpHeadersField = [String : String]
    
    private static let sharedInstance = MockURLSession()
    
    public var responses: [NSURL: Response] = [:]
    public var tasks: [NSURL: MockURLSessionDataTask] = [:]
    public var normalizer: MockURLSessionNormalizer = DefaultNormalizer()
    
    // MARK: - Mock methods
    public override class func sharedSession() -> NSURLSession {
        return MockURLSession.sharedInstance
    }
    
    public override func dataTaskWithURL(url: NSURL, completionHandler: CompletionHandler) -> NSURLSessionDataTask {
        let normalizedUrl = normalizer.normalizeUrl(url)
        let task = MockURLSessionDataTask(response: responses[normalizedUrl]!,
                                          completionHandler: completionHandler)
        tasks[normalizedUrl] = task
        return task
    }
    
    public class MockURLSessionDataTask: NSURLSessionDataTask {
        public var mockResponse: Response
        private (set) var called: [String: Response] = [:]
        let handler: CompletionHandler?
        
        init(response: Response, completionHandler: CompletionHandler?) {
            self.mockResponse = response
            self.handler = completionHandler
        }
        
        public override func resume() {
            registerCallee(mockResponse, name: "\(#function)")
            handler!(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        }
        
        public func registerCallee(value: Response, name: String) {
            return called[name] = value
        }
        
        public func callee(name: String) -> Response? {
            return called["\(name)()"]
        }
    }
    
    class DefaultNormalizer: MockURLSessionNormalizer {
        func normalizeUrl(url: NSURL) -> NSURL {
            return url
        }
    }
    
    // MARK: - Helpers
    public func setupMockResponse(url: NSURL,
                                  data: NSData,
                                  statusCode: Int = 200,
                                  httpVersion: String? = nil,
                                  headerFields: HttpHeadersField? = nil,
                                  error: NSError? = nil) -> Response? {
        let urlResponse = NSHTTPURLResponse(URL: url,
                                            statusCode: statusCode,
                                            HTTPVersion: httpVersion,
                                            headerFields: headerFields)
        return responses.updateValue((data: data, urlResponse: urlResponse, error: error),
                                     forKey: normalizer.normalizeUrl(url))
    }
    
    public func resumedResponse(url: NSURL, methodName: String = "resume") -> Response? {
        return tasks[normalizer.normalizeUrl(url)]?.callee(methodName)
    }
}
