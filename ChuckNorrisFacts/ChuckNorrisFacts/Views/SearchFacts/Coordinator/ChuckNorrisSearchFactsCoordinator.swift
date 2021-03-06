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
        let service = ChuckNorrisServices(with: URLSession.shared, api: ChuckNorrisAPI())
        let viewModel = ChuckNorrisSearchFactsViewModel(service, repository: ChuckNorrisRespository())
        viewModel.coordinatorDelegate = self
        let viewController = ChuckNorrisSearchFactsViewController(viewModel)
        self.viewController = viewController
    }
    
    // MARK: - Method required
    
    func stop() {
        navigation = nil
        viewController = nil
        childCoordinators = nil
    }
    
    // MARK: - Method
    
    func pop() {
        guard let navigation = self.navigation else { return }
        navigation.popViewController(animated: true)
        stop()
    }
}

extension ChuckNorrisSearchFactsCoordinator: ChuckNorrisSearchFactsCoordinatorDelgate {
    
    func backToHomeFacts(_ viewModel: ChuckNorrisSearchFactsViewModel, result: ChuckNorrisResultModel) {
        delegate?.backToHomeFacts(self, viewModel: viewModel, result: result)
        pop()
    }
}
