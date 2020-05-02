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
    
    // MARK: - Property
    
    var session: URLSessionProtocol!
    
    // MARK - Initialize
    
    init(_ session: URLSessionProtocol) {
        self.session = session
    }
    
    // MARK: - Request
    
    /// This method create a object request for user at requisitions
    /// - Parameters:
    ///   - url: url of service
    ///   - httpMethod: httpMethod
    func createRequest(from url: URL?, httpMethod: ChuckNorrisAPI.HTTPMethod) -> URLRequest? {
        guard let url = url else { return nil }
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
    func request(_ url: URL?,
                 httpMethod: ChuckNorrisAPI.HTTPMethod,
                 success: @escaping CompletionSuccess,
                 networkFailure: @escaping CompletionNetworkFailure,
                 chuckNorrisFailure: @escaping CompletionChuckNorrisFailure) {
        guard let request = createRequest(from: url, httpMethod: httpMethod) else { return }
        let dataTask = session.task(with: request) { (data, response, error) in
            self.handlerDataTaskResponse(data,
                                         response: response,
                                         error: error,
                                         success: success,
                                         networkFailure: networkFailure,
                                         chuckNorrisFailure: chuckNorrisFailure)
        }
        dataTask.resume()
    }
}

// MARK: Extension

extension ChuckNorrisRequest {
    
    private func handlerDataTaskResponse(_ data: Data?,
                                         response: URLResponse?,
                                         error: Error?,
                                         success: @escaping CompletionSuccess,
                                         networkFailure: @escaping CompletionNetworkFailure,
                                         chuckNorrisFailure: @escaping CompletionChuckNorrisFailure) {
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200...299:
                success(data, response)
            case 400...599:
                chuckNorrisFailure(data, response, ChuckNorrisError(response, error: error))
            default: return
            }
        } else {
            if let error = error {
                if error is URLError {
                    let urlError = error as? URLError
                    networkFailure(data, response, NetworkError(error: urlError))
                } else {
                    chuckNorrisFailure(data, response, ChuckNorrisError(response, error: error))
                }
                return
            }
        }
    }
}
