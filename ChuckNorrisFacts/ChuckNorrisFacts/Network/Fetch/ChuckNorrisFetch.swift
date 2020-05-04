//
//  ChuckNorrisFetch.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 13/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

class ChuckNorrisFetch {
    
    // MARK: - Property
    
    var chuckNorrisRequest: ChuckNorrisRequest!
    
    // MARK: - Initialize
    
    init(_ chuckNorrisRequest: ChuckNorrisRequest) {
        self.chuckNorrisRequest = chuckNorrisRequest
    }
    
    func fetch<T: Codable>(url: URL?,
                           httpMethod: ChuckNorrisAPI.HTTPMethod,
                           dataType: T.Type,
                           completion: @escaping (Result<T, ChuckNorrisError>) -> Void) {
        chuckNorrisRequest.request(url, httpMethod: httpMethod, success: { (data, response) in
            guard let data = data,
                let parse = ChuckNorrisParse.JSONDecodable(to: dataType, from: data) else {
                    completion(.failure(ChuckNorrisError.parse(nil)))
                    return
            }
            completion(.success(parse))
            return
        }, networkFailure: { (data, response, error) in
            completion(.failure(ChuckNorrisError.network(error)))
            return
        }) { (data, response, error) in
            completion(.failure(error))
            return
        }
    }
    
    func fetch<T: Codable>(url: URL?,
                           httpMethod: ChuckNorrisAPI.HTTPMethod,
                           dataType: [T].Type,
                           completion: @escaping (Result<[T], ChuckNorrisError>) -> Void) {
        chuckNorrisRequest.request(url, httpMethod: httpMethod, success: { (data, response) in
            guard let data = data,
                let parse = ChuckNorrisParse.JSONDecodable(to: dataType, from: data) else {
                    completion(.failure(ChuckNorrisError.parse(nil)))
                    return
            }
            completion(.success(parse))
            return
        }, networkFailure: { (data, response, error) in
            completion(.failure(ChuckNorrisError.network(error)))
            return
        }) { (data, response, error) in
            completion(.failure(error))
            return
        }
    }
}
