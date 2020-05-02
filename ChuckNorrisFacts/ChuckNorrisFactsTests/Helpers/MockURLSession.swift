//
//  MockURLSession.swift
//  ChuckNorrisFactsTests
//
//  Created by Gabriel Borges on 02/05/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation
@testable import ChuckNorrisFacts

class MockURLSession: URLSessionProtocol {
  
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    private (set) var lastURL: URL?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func task(with request: URLRequest, completionHandler: @escaping MockURLSession.DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }
}
