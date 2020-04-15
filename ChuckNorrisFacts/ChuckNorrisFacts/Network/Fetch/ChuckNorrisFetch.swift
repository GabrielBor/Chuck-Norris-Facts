//
//  ChuckNorrisFetch.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 13/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

class ChuckNorrisFetch {
    
    func fetch<V: Codable>(url: URL,
                           httpMethod: ChuckNorrisAPI.HTTPMethod,
                           dataType: V.Type,
                           completion: @escaping (Result<V, Error>) -> Void) {
        let request = ChuckNorrisRequest()
        request.request(url, httpMethod: httpMethod, success: { (data, response) in
            guard let data = data,
                let parse = ChuckNorrisParse.JSONDecodable(to: dataType, from: data) else {
                    completion(.failure(ChuckNorrisParseError.parse(nil)))
                    return
            }
            completion(.success(parse))
            return
        }, networkFailure: { (data, response, error) in
            completion(.failure(error))
            return
        }) { (data, response, error) in
            completion(.failure(error))
            return
        }
    }
    
    func fetch<V: Codable>(url: URL,
                           httpMethod: ChuckNorrisAPI.HTTPMethod,
                           dataType: [V].Type,
                           completion: @escaping (Result<[V], Error>) -> Void) {
        let request = ChuckNorrisRequest()
        request.request(url, httpMethod: httpMethod, success: { (data, response) in
            guard let data = data,
                let parse = ChuckNorrisParse.JSONDecodable(to: dataType, from: data) else {
                    completion(.failure(ChuckNorrisParseError.parse(nil)))
                    return
            }
            completion(.success(parse))
            return
        }, networkFailure: { (data, response, error) in
            completion(.failure(error))
            return
        }) { (data, response, error) in
            completion(.failure(error))
            return
        }
    }
}
