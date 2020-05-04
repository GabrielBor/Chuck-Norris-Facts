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
    
    var loadingBehaviorRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var errorPublishSubject: PublishSubject<ChuckNorrisError> = PublishSubject()
    var emptySearchResultBehaviorRelay: BehaviorRelay<[String]>?
    let listSuggestionBehaviorRelay: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var listLastSearhcesRelay: BehaviorRelay<[String]> = BehaviorRelay(value: [])

    var repository: ChuckNorrisRespository!
    let eight = 8
    var service: ChuckNorrisServices!
    weak var coordinatorDelegate: ChuckNorrisSearchFactsCoordinatorDelgate?
    
    // MARK: - Initialize
    
    init(_ service: ChuckNorrisServices, repository: ChuckNorrisRespository) {
        self.service = service
        self.repository = repository
    }
}

// MARK: - Services

extension ChuckNorrisSearchFactsViewModel {
    
    func fetchListSuggestionFacts() {
        loadingBehaviorRelay.accept(true)
        service.fetchListCategoryFacts { [weak self] result in
            guard let self = self else { return }
            self.loadingBehaviorRelay.accept(false)
            DispatchQueue.main.async {
                switch result {
                case .success(let suggestions):
                    self.handlerSuggetionsSuccess(with: suggestions)
                case .failure(let error):
                    self.handlerFailure(error)
                }
            }
        }
    }
    
    func fetchSearchCategoryFacts(from category: String) {
        loadingBehaviorRelay.accept(true)
        service.fetchSearchCategoryFact(category) { [weak self] result in
            guard let self = self else { return }
            self.loadingBehaviorRelay.accept(false)
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.handlerResultSuccess(with: result)
                case .failure(let error):
                    self.handlerFailure(error)
                }
            }
        }
    }
}

// MARK: - Methods

extension ChuckNorrisSearchFactsViewModel {
    
    // MARK: - Suggestions methods
    
    func randomSuggestions(_ suggestions: [String], randomElementsIn: Int) -> [String] {
        let random = suggestions
        return random[randomPick: randomElementsIn]
    }
    
    func fetchRuleSuggestions() {
        let suggestions = repository.getAll(.suggetionsKey)
        if suggestions.isEmpty {
            fetchListSuggestionFacts()
        } else {
            listSuggestionBehaviorRelay.accept(randomSuggestions(suggestions, randomElementsIn: eight))
        }
    }
    
    func handlerResultSuccess(with result: ChuckNorrisResultModel) {
        if result.result.isEmpty {
            emptySearchResultBehaviorRelay = BehaviorRelay(value: [])
        } else {
            coordinatorDelegate?.backToHomeFacts(self, result: result)
        }
    }
    
    func handlerSuggetionsSuccess(with suggestions: [String]) {
        repository.insert(.suggetionsKey, list: suggestions)
        let suggestions = repository.getAll(.suggetionsKey)
        listSuggestionBehaviorRelay.accept(randomSuggestions(suggestions, randomElementsIn: eight))
    }
    
    func handlerFailure(_ error: ChuckNorrisError) {
        errorPublishSubject.onNext(error)
    }
    
    // MARK: - SaveLastSearch methods
    
    func saveLastSearch(_ search: String) {
        if repository.contains(.lastSearchesKey, value: search) {
            loadLastSearches()
        } else {
            repository.insert(.lastSearchesKey, value: search)
            loadLastSearches()
        }
    }

    func loadLastSearches() {
        listLastSearhcesRelay.accept(repository.getAll(.lastSearchesKey).reversed())
    }
}
