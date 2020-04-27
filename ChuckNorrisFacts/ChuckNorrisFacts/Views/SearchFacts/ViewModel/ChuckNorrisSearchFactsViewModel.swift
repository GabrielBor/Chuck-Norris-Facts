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
    
    var loadingBehavior: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var errorPublish: PublishSubject<ChuckNorrisError> = PublishSubject()
    var emptySearchResultPublish: PublishSubject<[String]?> = PublishSubject()
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
    
    func fetchRuleSuggestions() {
        if let suggestions = loadFromStorage(.propertySuggestions) {
            listSuggestionPublish.onNext(randomSuggestions(suggestions))
            listSuggestionPublish.onCompleted()
        } else {
            fetchListSuggestionFacts()
        }
    }
    
    // MARK: Methods
    
    func randomSuggestions(_ suggestions: [String]) -> [String] {
        let random = suggestions
        return random[randomPick: 8]
    }
    
    func handlerSuccess(with result: ChuckNorrisResultModel) {
        if result.result.isEmpty {
            emptySearchResultPublish.onNext([])
        } else {
            delegate?.backToHomeFacts(self, result: result)
        }
    }
    
    func handlerSuccess(with suggestions: [String]) {
        self.saveInStorage(suggestions, key: .propertySuggestions)
        guard let suggestions = loadFromStorage(.propertySuggestions) else { return }
        listSuggestionPublish.onNext(randomSuggestions(suggestions))
        listSuggestionPublish.onCompleted()
    }
    
    func handlerFailure(_ error: ChuckNorrisError) {
        errorPublish.onNext(error)
    }
    
    func savePastSearch(_ search: String) {
        
    }
    
    // MARK: - CoreData Method
    
    func saveInStorage(_ suggestions: [String], key: IdentifierCoreData) {
        storage.save(to: suggestions, identifierEntity: .entitySuggestions, key: key)
    }
    
    func loadFromStorage(_ key: IdentifierCoreData) -> [String]? {
        guard let nsManagedList = storage.access(.entitySuggestions) else {
            return []
        }
        let storage = nsManagedList.first
        let suggestionsStorage = storage?.value(forKey: key.rawValue) as? [String]
        return suggestionsStorage
    }
}
