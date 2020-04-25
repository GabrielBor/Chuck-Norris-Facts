//
//  ChuckNorrisSearchFactsViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 16/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit
import RxSwift
import CoreData

protocol ChuckNorrisSearchFactsCoordinatorDelgate: AnyObject {
    
}

class ChuckNorrisSearchFactsViewModel {
    
    // MARK: - Propeties
    
    var loading: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<ChuckNorrisError> = PublishSubject()
    var listSuggestionPublish: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    var searchCategoryPublish: PublishSubject<ChuckNorrisResultModel> = PublishSubject()
    
    let storage = ChuckNorrisStorage()
    var service: ChuckNorrisServices!
    weak var coordinatorDelegate: ChuckNorrisSearchFactsCoordinatorDelgate?
    
    // MARK: - Initialize
    
    init(_ service: ChuckNorrisServices,
         coordinatorDelegate: ChuckNorrisSearchFactsCoordinatorDelgate? = nil) {
        self.service = service
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    // MARK: - Services
    
    func fetchListSuggestionFacts() {
        loading.onNext(true)
        service.fetchListCategoryFacts { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.loading.onNext(false)
                self.loading.onCompleted()
                switch result {
                case .success(let suggestions):
                    self.handlerSuccess(with: suggestions)
                case .failure(let error):
                    self.handlerFailure(error)
                }
            }
        }
    }
    
    func fetchSearchCategoryFacts(from category: String) {
        loading.onNext(true)
        service.fetchSearchCategoryFact(category) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.loading.onNext(false)
                self.loading.onCompleted()
                switch result {
                case .success(let result):
                    self.searchCategoryPublish.onNext(result)
                    self.searchCategoryPublish.onCompleted()
                case .failure(let error):
                    self.handlerFailure(error)
                }
            }
        }
    }
    
    func handlerSuccess(with result: ChuckNorrisResultModel) {
        self.searchCategoryPublish.onNext(result)
        self.searchCategoryPublish.onCompleted()
    }
    
    func handlerSuccess(with suggestions: [String]) {
        self.saveSuggestionsStorage(suggestions)
        listSuggestionPublish.onNext(randomSuggestions(loadSuggestionsStorage()))
        listSuggestionPublish.onCompleted()
    }
    
    func handlerFailure(_ error: ChuckNorrisError) {
        self.error.onNext(error)
        self.error.onCompleted()
    }
    
    // MARK: - CoreData Method
    
    func saveSuggestionsStorage(_ suggestions: [String]) {
        storage.save(to: suggestions, identifierEntity: .entitySuggestions, key: .propertySuggestions)
    }
    
    func loadSuggestionsStorage() -> [String] {
        guard let nsManagedList = storage.access(.entitySuggestions) else {
            return []
        }
        let storage = nsManagedList.first
        let suggestionsStorage = storage?.value(forKey: IdentifierCoreData.propertySuggestions.rawValue) as! [String]
        return suggestionsStorage
    }
    
    // MARK: Methods
    
    func randomSuggestions(_ suggestions: [String]) -> [String] {
        let random = suggestions
        return random[randomPick: 8]
    }
}
