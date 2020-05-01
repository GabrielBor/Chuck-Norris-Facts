//
//  ChuckNorrisSearchFactsViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 16/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

// MARK: - CoordinatorDelegate

protocol ChuckNorrisSearchFactsCoordinatorDelgate: AnyObject {
    func backToHomeFacts(_ viewModel: ChuckNorrisSearchFactsViewModel, result: ChuckNorrisResultModel)
}

class ChuckNorrisSearchFactsViewModel {
    
    // MARK: - Propeties
    
    var loadingRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var errorPublish: PublishSubject<ChuckNorrisError> = PublishSubject()
    var emptySearchResultPublish: PublishSubject<[String]?> = PublishSubject()
    var listSuggestionPublish: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    var searchCategoryPublish: PublishSubject<ChuckNorrisResultModel> = PublishSubject()
    var listLastSearhcesRelay: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    var listSearcheds = [String]()
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
        loadingRelay.accept(true)
        service.fetchListCategoryFacts { [weak self] result in
            guard let self = self else { return }
            self.loadingRelay.accept(false)
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
        loadingRelay.accept(true)
        service.fetchSearchCategoryFact(category) { [weak self] result in
            guard let self = self else { return }
            self.loadingRelay.accept(false)
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

// MARK: - Methods

extension ChuckNorrisSearchFactsViewModel {
    
    func randomSuggestions(_ suggestions: [String]) -> [String] {
        let random = suggestions
        return random[randomPick: 8]
    }
    
    func fetchRuleSuggestions() {
        let suggestions = getValue(withThe: .suggetionsKey)
        if suggestions.isEmpty {
            fetchListSuggestionFacts()
        } else {
            listSuggestionPublish.onNext(randomSuggestions(suggestions))
            listSuggestionPublish.onCompleted()
        }
    }
    
    func handlerSuccess(with result: ChuckNorrisResultModel) {
        if result.result.isEmpty {
            emptySearchResultPublish.onNext([])
        } else {
            coordinatorDelegate?.backToHomeFacts(self, result: result)
        }
    }
    
    func handlerSuccess(with suggestions: [String]) {
        saveValue(withThe: .suggetionsKey, withValue: suggestions)
        let suggestions = getValue(withThe: .suggetionsKey)
        listSuggestionPublish.onNext(randomSuggestions(suggestions))
        listSuggestionPublish.onCompleted()
    }
    
    func handlerFailure(_ error: ChuckNorrisError) {
        errorPublish.onNext(error)
    }
    
    func saveLastSearch(_ search: String) {
        if contains(key: .lastSearchesKey, search: search) {
            loadLastSearches()
        } else {
            insertValue(with: search)
            loadLastSearches()
        }
    }

    func loadLastSearches() {
        let lastSearches = getValue(withThe: .lastSearchesKey)
        listLastSearhcesRelay.accept(lastSearches)
    }
}

// MARK: - UserDefaults methods

extension ChuckNorrisSearchFactsViewModel {
    
    func contains(key: IdentifierKey, search: String) -> Bool {
        guard let list = UserDefaults.standard.object(forKey: key.rawValue) as? [String] else { return false }
        return list.contains(search)
    }
    
    func getValue(withThe key: IdentifierKey) -> [String] {
        guard let value = UserDefaults.standard.array(forKey: key.rawValue) as? [String] else { return [] }
        return value
    }
    
    func insertValue(with value: String) {
        listSearcheds.append(value)
        saveValue(withThe: .lastSearchesKey, withValue: listSearcheds)
    }
    
    func saveValue(withThe key: IdentifierKey, withValue value: [String]?) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}

