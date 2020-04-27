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

protocol ChuckNorrisSearchFactsViewModelDelgate: AnyObject {
    func backToHomeFacts(_ viewModel: ChuckNorrisSearchFactsViewModel, result: ChuckNorrisResultModel)
}

class ChuckNorrisSearchFactsViewModel {
    
    // MARK: - Propeties
    
    var loading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var error: PublishSubject<ChuckNorrisError> = PublishSubject()
    var emptySearchResult: PublishSubject<[String]?> = PublishSubject()
    var listSuggestionPublish: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    var searchCategoryPublish: PublishSubject<ChuckNorrisResultModel> = PublishSubject()
    
    let storage = ChuckNorrisStorage()
    var service: ChuckNorrisServices!
    weak var delegate: ChuckNorrisSearchFactsViewModelDelgate?
    
    // MARK: - Initialize
    
    init(_ service: ChuckNorrisServices) {
        self.service = service
    }
    
    // MARK: - Services
    
    func fetchListSuggestionFacts() {
        loading.onNext(true)
        service.fetchListCategoryFacts { [weak self] result in
            guard let self = self else { return }
            self.loading.onNext(false)
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
        loading.onNext(true)
        service.fetchSearchCategoryFact(category) { [weak self] result in
            guard let self = self else { return }
            self.loading.onNext(false)
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
    
    // MARK: Methods
    
    func randomSuggestions(_ suggestions: [String]) -> [String] {
        let random = suggestions
        return random[randomPick: 8]
    }
    
    func fetchRuleSuggestions() {
        if let suggestions = loadSuggestionsStorage() {
            listSuggestionPublish.onNext(randomSuggestions(suggestions))
            listSuggestionPublish.onCompleted()
        } else {
            fetchListSuggestionFacts()
        }
    }
    
    func handlerSuccess(with result: ChuckNorrisResultModel) {
        if result.result.isEmpty {
            emptySearchResult.onNext([])
            emptySearchResult.onCompleted()
        } else {
            delegate?.backToHomeFacts(self, result: result)
        }
    }
    
    func handlerSuccess(with suggestions: [String]) {
        self.saveSuggestionsStorage(suggestions)
        guard let suggestions = loadSuggestionsStorage() else { return }
        listSuggestionPublish.onNext(randomSuggestions(suggestions))
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
    
    func loadSuggestionsStorage() -> [String]? {
        guard let nsManagedList = storage.access(.entitySuggestions) else {
            return []
        }
        let storage = nsManagedList.first
        let suggestionsStorage = storage?.value(forKey: IdentifierCoreData.propertySuggestions.rawValue) as? [String]
        return suggestionsStorage
    }
}
