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
    
    var chuckNorrisFetch = ChuckNorrisFetch()
    var chuckNorrisAPI = ChuckNorrisAPI()
    
    // MARK: - Services
    
    func fetchRandomFact(completion: @escaping (Result<ChuckNorrisRandomModel, ChuckNorrisError>) -> Void) {
        chuckNorrisFetch.fetch(url: chuckNorrisAPI.urlService(.random), httpMethod: .get, dataType: ChuckNorrisRandomModel.self) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchCategoryFact(_ value: String, completion: @escaping (Result<ChuckNorrisRandomModel, ChuckNorrisError>) -> Void) {
        chuckNorrisFetch.fetch(url: chuckNorrisAPI.urlService(.category(value: value)),
                               httpMethod: .get,
                               dataType: ChuckNorrisRandomModel.self) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchListCategoryFacts(completion: @escaping (Result<[String], ChuckNorrisError>) -> Void) {
        chuckNorrisFetch.fetch(url: chuckNorrisAPI.urlService(.listCategory), httpMethod: .get, dataType: [String].self) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchFreeTextFact(_ value: String, completion: @escaping (Result<ChuckNorrisFreeTextModel, ChuckNorrisError>) -> Void) {
        chuckNorrisFetch.fetch(url: chuckNorrisAPI.urlService(.freeText(value: value)), httpMethod: .get, dataType: ChuckNorrisFreeTextModel.self) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
