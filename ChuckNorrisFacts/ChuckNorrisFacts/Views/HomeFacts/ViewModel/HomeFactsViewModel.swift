//
//  HomeFactsViewModel.swift
//  ChuckNorris
//
//  Created by Gabriel Borges on 12/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeFactsViewModelCoordinatorDelegate: AnyObject {
    func goToSearchFacts(_ viewModel: HomeFactsViewModel)
}

class HomeFactsViewModel {
    
    // MARK: - Properties
    
    var factsList: [ChuckNorrisRandomModel] = []
    var publishFacts = PublishSubject<[ChuckNorrisRandomModel]>()
    weak var coordinatorDelegate: HomeFactsViewModelCoordinatorDelegate?
    
    // MARK: - Initialize
    
    init(_ factsList: [ChuckNorrisRandomModel], coordinatorDelegate: HomeFactsViewModelCoordinatorDelegate? = nil) {
        self.factsList = factsList
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    // MARK: - OnNext
    
    func setupOnNextFactList() {
        publishFacts.onNext(factsList)
        publishFacts.onCompleted()
    }
    
    // MARK: - Mehtod

    func sizeFont(for fact: String) -> CGFloat {
        return fact.count > 80 ? 24.0 : 16.0
    }
    
    // MARK: - Coordinator method
    
    func goToSearchFacts() {
        coordinatorDelegate?.goToSearchFacts(self)
    }
}
