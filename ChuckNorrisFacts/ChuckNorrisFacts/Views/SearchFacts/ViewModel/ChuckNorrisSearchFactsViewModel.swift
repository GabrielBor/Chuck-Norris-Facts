//
//  ChuckNorrisSearchFactsViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 16/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

// MARK: - CoordinatorDelegate

protocol ChuckNorrisSearchFactsCoordinatorDelgate: AnyObject {
    func backToHomeFacts(_ viewModel: ChuckNorrisSearchFactsViewModel, result: ChuckNorrisResultModel)
}

class ChuckNorrisSearchFactsViewModel {
    
    // MARK: - Propeties
    
    var loadingBehavior: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var errorPublish: PublishSubject<ChuckNorrisError> = PublishSubject()
    var emptySearchResultPublish: PublishSubject<[String]?> = PublishSubject()
    var listSuggestionPublish: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    var searchCategoryPublish: PublishSubject<ChuckNorrisResultModel> = PublishSubject()
    var listLastSearhcesBehavior: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    
    let storage = ChuckNorrisStorage()
    var service: ChuckNorrisServices!
    weak var coordinatorDelegate: ChuckNorrisSearchFactsCoordinatorDelgate?
    
    // MARK: - Initialize
    
    init(_ service: ChuckNorrisServices) {
        self.service = service
    }
}

// MARK: - Services

extension ChuckNorrisSearchFactsViewModel {
    
    func fetchListSuggestionFacts() {
        loadingBehavior.onNext(true)
        service.fetchListCategoryFacts { [weak self] result in
            guard let self = self else { return }
            self.loadingBehavior.onNext(false)
            DispatchQueue.main.async {
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
        loadingBehavior.onNext(true)
        service.fetchSearchCategoryFact(category) { [weak self] result in
            guard let self = self else { return }
            self.loadingBehavior.onNext(false)
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.handlerSuccess(with: result)
                case .failure(let error):
                    self.handlerFailure(error)
                }
            }
        }
    }
}

// MARK: - Rule methods

extension ChuckNorrisSearchFactsViewModel {
    
    func fetchRuleSuggestions() {
        if let suggestions = loadFromStorage(.entitySuggestions, key: .propertySuggestions) {
            listSuggestionPublish.onNext(randomSuggestions(suggestions))
            listSuggestionPublish.onCompleted()
        } else {
            fetchListSuggestionFacts()
        }
    }
    
    func randomSuggestions(_ suggestions: [String]) -> [String] {
        let random = suggestions
        return random[randomPick: 8]
    }
    
    func handlerSuccess(with result: ChuckNorrisResultModel) {
        if result.result.isEmpty {
            emptySearchResultPublish.onNext([])
        } else {
            coordinatorDelegate?.backToHomeFacts(self, result: result)
        }
    }
    
    func handlerSuccess(with suggestions: [String]) {
        saveInStorage(at: .entitySuggestions, key: .propertySuggestions, value: suggestions)
        guard let suggestions = loadFromStorage(.entitySuggestions, key: .propertySuggestions) else { return }
        listSuggestionPublish.onNext(randomSuggestions(suggestions))
        listSuggestionPublish.onCompleted()
    }
    
    func handlerFailure(_ error: ChuckNorrisError) {
        errorPublish.onNext(error)
    }
    
    func savePastSearch(_ search: String) {
        if !containsInStorage(with: .entityLastSearch, key: .propertyLastSearches, value: search) {
//            pastSearchList.append(search)
//            saveInStorage(at: .entityLastSearch, key: .propertyLastSearches, value: pastSearchList)
            loadListPastSearch()
        }
    }
    
    func loadListPastSearch() {
        if let listPastSearch = loadFromStorage(.entityLastSearch, key: .propertyLastSearches) {
            listLastSearhcesBehavior.onNext(listPastSearch)
        }
    }
}

// MARK: - CoreData mehtods

extension ChuckNorrisSearchFactsViewModel {
    
    func saveInStorage(at entityName: IdentifierEntity, key: IdentifierProperty, value: [String]) {
        storage.save(at: entityName, withThe: key, withValue: value)
    }
    
    func containsInStorage(with entity: IdentifierEntity, key: IdentifierProperty, value: String) -> Bool {
        return storage.contains(at: entity, withThe: key, withValue: value)
    }
    
    func loadFromStorage(_ entityName: IdentifierEntity, key: IdentifierProperty) -> [String]? {
        guard let nsManagedList = storage.access(entityName) else {
            return []
        }
        let storage = nsManagedList.first
        let suggestionsStorage = storage?.value(forKey: key.rawValue) as? [String]
        return suggestionsStorage
    }
}

