//
//  ChuckNorrisSearchFactsViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 16/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit
import RxSwift

protocol ChuckNorrisSearchFactsCoordinatorDelgate: AnyObject {
    
}

class ChuckNorrisSearchFactsViewModel {
    
    // MARK: - Propeties
    
    var loading: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<ChuckNorrisError> = PublishSubject()
    var listSuggestionPublish: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    var searchCategoryPublish: PublishSubject<ChuckNorrisResultModel> = PublishSubject()
    
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
                case .success(let categories):
                    self.listSuggestionPublish.onNext(categories)
                    self.listSuggestionPublish.onCompleted()
                case .failure(let error):
                    self.error.onNext(error)
                    self.error.onCompleted()
                }
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
