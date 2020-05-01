//
//  HomeFactsViewModel.swift
//  ChuckNorris
//
//  Created by Gabriel Borges on 12/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit
import RxSwift

//MARK: - CoordinatorDelegate

protocol HomeFactsViewModelDelegate: AnyObject {
    func goToSearchFacts(_ viewModel: HomeFactsViewModel)
}

class HomeFactsViewModel {
    
    // MARK: - Enum
    
    enum SizeFont: CGFloat {
        case numberMaxOfCaracter = 80
        case maxFontSize = 24
        case minFontSize = 16
    }
    
    // MARK: - Properties
    
    var factsList: [ChuckNorrisModel] = []
    var factsPublish: PublishSubject<[ChuckNorrisModel]> = PublishSubject()
    weak var delegate: HomeFactsViewModelDelegate?
    
    // MARK: - Methods
    
    func updateFactsList(with newFactsList: [ChuckNorrisModel]) {
        factsList = newFactsList
        factsPublish.onNext(factsList)
    }

    func sizeFont(for fact: String) -> CGFloat {
        return fact.count > SizeFont.numberMaxOfCaracter.hashValue ? SizeFont.maxFontSize.rawValue : SizeFont.minFontSize.rawValue
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
