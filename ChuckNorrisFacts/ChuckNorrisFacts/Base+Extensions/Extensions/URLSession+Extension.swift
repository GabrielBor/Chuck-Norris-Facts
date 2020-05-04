//
//  URLSession+Extension.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 02/05/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

extension URLSession: URLSessionProtocol {
    
    /// Required function for implements dataTask from URLSession
    /// - Parameters:
    ///   - request: URLRequest
    ///   - completionHandler: @escaping DataTaskResult
    func task(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}
extension URLSessionDataTask: URLSessionDataTaskProtocol { }
