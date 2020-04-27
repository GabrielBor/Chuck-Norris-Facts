//
//  ChuckNorrisSearchFactsCoordinator.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 18/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

// MARK: - CoordinatorDelegate

protocol ChuckNorrisSearchFactsCoordinatorDelegate: AnyObject {
    func backToHomeFacts(_ coordinator: ChuckNorrisSearchFactsCoordinator,
                         viewModel: ChuckNorrisSearchFactsViewModel, result: ChuckNorrisResultModel)
}

class ChuckNorrisSearchFactsCoordinator: BaseCoordinator {
   
    // MARK: - Propeties

    var childCoordinators: [BaseCoordinator]?
    var navigation: UINavigationController?
    var viewController: UIViewController?
    weak var delegate: ChuckNorrisSearchFactsCoordinatorDelegate?
    
    // MARK: - Initialize
    
    init() {
        let viewModel = ChuckNorrisSearchFactsViewModel(ChuckNorrisServices())
        viewModel.delegate = self
        let viewController = ChuckNorrisSearchFactsViewController(viewModel)
        self.viewController = viewController
    }
    
    // MARK: - Methods
    
    func stop() {
        navigation = nil
        viewController = nil
        childCoordinators = nil
    }
    
    func pop() {
        guard let navigation = self.navigation else { return }
        navigation.popViewController(animated: true)
        stop()
    }
}

extension ChuckNorrisSearchFactsCoordinator: ChuckNorrisSearchFactsViewModelDelgate {
    
    func backToHomeFacts(_ viewModel: ChuckNorrisSearchFactsViewModel, result: ChuckNorrisResultModel) {
        delegate?.backToHomeFacts(self, viewModel: viewModel, result: result)
        pop()
    }
}
