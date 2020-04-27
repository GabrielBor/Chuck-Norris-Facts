//
//  HomeFactsViewModel.swift
//  ChuckNorris
//
//  Created by Gabriel Borges on 12/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit
import RxSwift

protocol HomeFactsViewModelDelegate: AnyObject {
    func goToSearchFacts(_ viewModel: HomeFactsViewModel)
}

class HomeFactsViewModel {
    
    // MARK: - Properties
    
    var factsList: [ChuckNorrisModel] = []
    var factsPublish: PublishSubject<[ChuckNorrisModel]> = PublishSubject()
    weak var delegate: HomeFactsViewModelDelegate?
    
    // MARK: - Mehtod
    
    func updateFactsList(with newFactsList: [ChuckNorrisModel]) {
        factsList = newFactsList
        factsPublish.onNext(factsList)
        factsPublish.onCompleted()
    }

    func sizeFont(for fact: String) -> CGFloat {
        return fact.count > 80 ? 24.0 : 16.0
    }
    
    func setUncategorizedIfNeeded(_ category: String?) -> String {
        guard let categoryValue = category else {
            return "UNCATEGORIZED"
        }
        return categoryValue
    }
    
    func clearFactsList() {
        factsList = []
    }
    
    // MARK: - Coordinator method
    
    func goToSearchFacts() {
        delegate?.goToSearchFacts(self)
    }
}
