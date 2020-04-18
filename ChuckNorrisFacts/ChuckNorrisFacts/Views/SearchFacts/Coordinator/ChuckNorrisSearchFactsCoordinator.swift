//
//  ChuckNorrisSearchFactsCoordinator.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 18/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

class ChuckNorrisSearchFactsCoordinator: BaseCoordinator {
    
    // MARK: - Propeties
    
    var childCoordinators: [BaseCoordinator]?
    var navigation: UINavigationController?
    var viewController: UIViewController?
    
    // MARK: - Initialize
    
    init() {
        let viewModel = ChuckNorrisSearchFactsViewModel(ChuckNorrisServices(), coordinatorDelegate: self)
        let viewController = ChuckNorrisSearchFactsViewController(viewModel)
        self.viewController = viewController
    }
    
    // MARK: - Methods
    
    func stop() {
        childCoordinators = nil
        navigation = nil
        viewController = nil
    }
}

extension ChuckNorrisSearchFactsCoordinator: ChuckNorrisSearchFactsCoordinatorDelgate {
    
}
