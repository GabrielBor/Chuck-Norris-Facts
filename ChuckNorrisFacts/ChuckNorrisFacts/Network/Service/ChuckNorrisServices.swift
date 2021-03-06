//
//  ChuckNorrisServices.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 13/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

class ChuckNorrisServices {
    
    // MARK: Properties
    
    var chuckNorrisFetch: ChuckNorrisFetch!
    var chuckNorrisAPI: ChuckNorrisAPI!
    
    // MARK: - Initialize
    
    init(with session: URLSessionProtocol, api: ChuckNorrisAPI) {
        chuckNorrisFetch = ChuckNorrisFetch(ChuckNorrisRequest(session))
        chuckNorrisAPI = api
    }
    
    // MARK: - Services
    
    func fetchRandomFact(completion: @escaping (Result<ChuckNorrisModel, ChuckNorrisError>) -> Void) {
        chuckNorrisFetch.fetch(url: chuckNorrisAPI.urlService(.random), httpMethod: .get, dataType: ChuckNorrisModel.self) { (result) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCategoryFact(_ value: String, completion: @escaping (Result<ChuckNorrisModel, ChuckNorrisError>) -> Void) {
        chuckNorrisFetch.fetch(url: chuckNorrisAPI.urlService(.category(value: value)), httpMethod: .get, dataType: ChuckNorrisModel.self) { (result) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchListCategoryFacts(completion: @escaping (Result<[String], ChuckNorrisError>) -> Void) {
        chuckNorrisFetch.fetch(url: chuckNorrisAPI.urlService(.listCategory), httpMethod: .get, dataType: [String].self) { (result) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSearchCategoryFact(_ value: String,
                                 completion: @escaping (Result<ChuckNorrisResultModel, ChuckNorrisError>) -> Void) {
        chuckNorrisFetch.fetch(url: chuckNorrisAPI.urlService(.searchCategory(value: value)), httpMethod: .get, dataType: ChuckNorrisResultModel.self) { (result) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
