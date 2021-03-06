//
//  URLSessionProtocol.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 02/05/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func task(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}
