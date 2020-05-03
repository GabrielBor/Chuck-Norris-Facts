//
//  MockURLSession.swift
//  ChuckNorrisFactsTests
//
//  Created by Gabriel Borges on 02/05/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation
@testable import ChuckNorrisFacts

class MockURLSession {
    
    // MARK: - Properties
    
    var dataTask = MockURLSessionDataTask()
    private var mockData: Data?
    private var mockError: ChuckNorrisError?
    private var mockStatusCode = 0
    
    // MARK: - Methods
    
    func success(with data: Data?) {
        mockData = data
        mockStatusCode = 200
    }
    
    func failure(with error: ChuckNorrisError?) {
        mockError = error
        mockStatusCode = 400
    }
    
    private func registerResponse(request: URLRequest) -> URLResponse {
        let response = HTTPURLResponse(url: request.url!, statusCode: mockStatusCode, httpVersion: "HTTP/1.1", headerFields: nil)!
        return response
    }
}

// MARK: - URLSessionProtocol

extension MockURLSession: URLSessionProtocol {
    
    func task(with request: URLRequest, completionHandler: @escaping MockURLSession.DataTaskResult) -> URLSessionDataTaskProtocol {
        completionHandler(mockData, registerResponse(request: request), mockError)
        return dataTask
    }
}
