//
//  HomeFactsViewModel.swift
//  ChuckNorris
//
//  Created by Gabriel Borges on 12/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

//MARK: - CoordinatorDelegate

protocol HomeFactsCoordinatorDelegate: AnyObject {
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
    var factsPublishSubject: PublishSubject<[ChuckNorrisModel]> = PublishSubject()
    weak var coordinatorDelegate: HomeFactsCoordinatorDelegate?
    
    // MARK: - Methods
    
    func updateFactsList(with newFactsList: [ChuckNorrisModel]) {
        factsList = newFactsList
        factsPublishSubject.onNext(newFactsList)
    }

    func sizeFont(for fact: String) -> CGFloat {
        let maxCharacter = Int(SizeFont.numberMaxOfCaracter.rawValue)
        let decisionSizeFont = fact.count < maxCharacter
        return decisionSizeFont ? SizeFont.maxFontSize.rawValue : SizeFont.minFontSize.rawValue
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
        coordinatorDelegate?.goToSearchFacts(self)
    }
}
