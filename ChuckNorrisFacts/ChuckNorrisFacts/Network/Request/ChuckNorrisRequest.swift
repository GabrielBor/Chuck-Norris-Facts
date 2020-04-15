//
//  ChuckNorrisRequest.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 13/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

class ChuckNorrisRequest {
    
    // MARK: - Typelias
    
    typealias CompletionSuccess = (_ data: Data?, _ response: URLResponse?) -> Void
    typealias CompletionChuckNorrisFailure = (_ data: Data?, _ response: URLResponse?, _ error: ChuckNorrisError) -> Void
    typealias CompletionNetworkFailure = (_ data: Data?, _ response: URLResponse?, _ error: NetworkError) -> Void
    
    // MARK: - Request
    
    /// This method create a object request for user at requisitions
    /// - Parameters:
    ///   - url: url of service
    ///   - httpMethod: httpMethod
    func createRequest(from url: URL, httpMethod: ChuckNorrisAPI.HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }
    
    /// This method create the request task
    /// - Parameters:
    ///   - url: url of service
    ///   - httpMethod: httpMethod
    ///   - success: callback of success with object data and response
    ///   - failure: callback of failure with object data, response and errors of chuck or network
    func request(_ url: URL,
                 httpMethod: ChuckNorrisAPI.HTTPMethod,
                 success: @escaping CompletionSuccess,
                 networkFailure: @escaping CompletionNetworkFailure,
                 chuckNorrisFailure: @escaping CompletionChuckNorrisFailure) {
        let request = createRequest(from: url, httpMethod: httpMethod)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                if error is URLError {
                    networkFailure(data, response, NetworkError(response, error: error))
                } else {
                    chuckNorrisFailure(data, response, ChuckNorrisError(response, error: error))
                }
                return
            }
            success(data, response)
        }
        dataTask.resume()
    }
}
