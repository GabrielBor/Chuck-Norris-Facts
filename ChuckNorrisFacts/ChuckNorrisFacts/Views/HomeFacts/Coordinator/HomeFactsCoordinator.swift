//
//  HomeFactsCoordinator.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 20/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

class HomeFactsCoordinator: BaseCoordinator {
    
    var childCoordinators: [BaseCoordinator]?
    var navigation: UINavigationController?
    var viewController: UIViewController?
    
    init(_ factsList: [ChuckNorrisRandomModel]) {
        let viewModel = HomeFactsViewModel(factsList, coordinatorDelegate: self)
        let viewController = HomeFactsViewController(viewModel)
        self.viewController = viewController
    }
    
    func stop() {
        childCoordinators = nil
        navigation = nil
        viewController = nil
    }
}

extension HomeFactsCoordinator: HomeFactsViewModelCoordinatorDelegate {
    func goToSearchFacts(_ viewModel: HomeFactsViewModel) {
        guard let navigation = navigation else { return }
        let coordinator = ChuckNorrisSearchFactsCoordinator()
        childCoordinators?.append(coordinator)
        coordinator.start(using: .push(navigation), animated: true)
    }
}
