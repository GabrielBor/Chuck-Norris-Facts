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
    
    var repository = ChuckNorrisRespository()
    var lastSearches = [String]()
    let randomNumber = 8
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
    
    // MARK: - Suggestions methods
    
    func randomSuggestions(_ suggestions: [String]) -> [String] {
        let random = suggestions
        return random[randomPick: randomNumber]
    }
    
    func fetchRuleSuggestions() {
        let suggestions = repository.getAll(.suggetionsKey)
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
        repository.insert(.suggetionsKey, list: suggestions)
        let suggestions = repository.getAll(.suggetionsKey)
        listSuggestionPublish.onNext(randomSuggestions(suggestions))
        listSuggestionPublish.onCompleted()
    }
    
    func handlerFailure(_ error: ChuckNorrisError) {
        errorPublish.onNext(error)
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
        let lastSearches = repository.getAll(.lastSearchesKey)
        listLastSearhcesRelay.accept(lastSearches)
    }
}
