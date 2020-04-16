//
//  ChuckNorrisFetch.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 13/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

class ChuckNorrisFetch {
    
    func fetch<V: Codable>(url: URL?,
                           httpMethod: ChuckNorrisAPI.HTTPMethod,
                           dataType: V.Type,
                           completion: @escaping (Result<V, ChuckNorrisError>) -> Void) {
        guard let url = url else { return }
        let request = ChuckNorrisRequest()
        request.request(url, httpMethod: httpMethod, success: { (data, response) in
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
    
    func fetch<V: Codable>(url: URL?,
                           httpMethod: ChuckNorrisAPI.HTTPMethod,
                           dataType: [V].Type,
                           completion: @escaping (Result<[V], ChuckNorrisError>) -> Void) {
        guard let url = url else { return }
        let request = ChuckNorrisRequest()
        request.request(url, httpMethod: httpMethod, success: { (data, response) in
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
