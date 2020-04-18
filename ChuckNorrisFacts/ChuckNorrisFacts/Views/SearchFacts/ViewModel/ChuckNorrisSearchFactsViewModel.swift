//
//  ChuckNorrisSearchFactsViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 16/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

// MARK: ViewDelegate

protocol ChuckNorrisSearchFactsViewDelegate: AnyObject {
    func chuckNorrisListFacts(_ viewModel: ChuckNorrisSearchFactsViewModel, withSuccess categories: [String])
    func chuckNorrisListFacts(_ viewModel: ChuckNorrisSearchFactsViewModel, withFailure error: ChuckNorrisError)
    func chuckNorrisSearchFacts(_ viewModel: ChuckNorrisSearchFactsViewModel, withSuccess result: ChuckNorrisResultModel)
    func chuckNorrisSearchFacts(_ viewModel: ChuckNorrisSearchFactsViewModel, withFailure error: ChuckNorrisError)
}

protocol ChuckNorrisSearchFactsCoordinatorDelgate: AnyObject {
    
}

class ChuckNorrisSearchFactsViewModel {
    
    // MARK: - Propeties
    
    var service: ChuckNorrisServices!
    weak var viewDelegate: ChuckNorrisSearchFactsViewDelegate?
    weak var coordinatorDelegate: ChuckNorrisSearchFactsCoordinatorDelgate?
    
    // MARK: - Initialize
    
    init(_ service: ChuckNorrisServices,
         viewDelegate: ChuckNorrisSearchFactsViewDelegate? = nil,
         coordinatorDelegate: ChuckNorrisSearchFactsCoordinatorDelgate? = nil) {
        self.service = service
        self.viewDelegate = viewDelegate
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    // MARK: - Services
    
    func fetchListCategoryFacts() {
        service.fetchListCategoryFacts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                self.viewDelegate?.chuckNorrisListFacts(self, withSuccess: categories)
            case .failure(let error):
                self.viewDelegate?.chuckNorrisListFacts(self, withFailure: error)
            }
        }
    }
    
    func fetchSearchCategoryFacts(from category: String) {
        service.fetchSearchCategoryFact(category) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.viewDelegate?.chuckNorrisSearchFacts(self, withSuccess: result)
            case .failure(let error):
                self.viewDelegate?.chuckNorrisSearchFacts(self, withFailure: error)
            }
        }
    }
}
