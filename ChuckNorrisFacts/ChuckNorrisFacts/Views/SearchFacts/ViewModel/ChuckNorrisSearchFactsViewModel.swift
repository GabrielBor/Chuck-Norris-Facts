//
//  ChuckNorrisSearchFactsViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 16/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import RxRelay
import RxSwift

protocol ChuckNorrisSearchFactsCoordinatorDelgate: AnyObject {
    
}

class ChuckNorrisSearchFactsViewModel {
    
    // MARK: - Propeties
    
    var loading = PublishSubject<Bool>()
    var error = PublishSubject<ChuckNorrisError>()
    var listSuggestionPublish = PublishSubject<[String]>()
    var searchCategoryPublish = PublishSubject<ChuckNorrisResultModel>()
    
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
            guard let self = self else { return }
            self.loading.onNext(false)
            switch result {
            case .success(let categories):
                self.listSuggestionPublish.onNext(categories)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
    
    func fetchSearchCategoryFacts(from category: String) {
        loading.onNext(true)
        service.fetchSearchCategoryFact(category) { [weak self] result in
            guard let self = self else { return }
            self.loading.onNext(false)
            switch result {
            case .success(let result):
                self.searchCategoryPublish.onNext(result)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
}
