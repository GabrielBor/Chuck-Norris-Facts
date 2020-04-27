//
//  HomeFactsCoordinator.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 20/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

class HomeFactsCoordinator: BaseCoordinator {
  
    var navigation: UINavigationController?
    var viewController: UIViewController?
    var childCoordinators: [BaseCoordinator]?

    init() {
        childCoordinators = []
        let viewModel = HomeFactsViewModel()
        viewModel.delegate = self
        let viewController = HomeFactsViewController(viewModel)
        self.viewController = viewController
    }
    
    func stop() {
        navigation = nil
        viewController = nil
        childCoordinators = nil
    }
}

extension HomeFactsCoordinator: HomeFactsViewModelDelegate {
    func goToSearchFacts(_ viewModel: HomeFactsViewModel) {
        guard let navigation = navigation else { return }
        let coordinator = ChuckNorrisSearchFactsCoordinator()
        coordinator.delegate = self
        childCoordinators?.append(coordinator)
        coordinator.start(using: .push(navigation), animated: true)
    }
}

extension HomeFactsCoordinator: ChuckNorrisSearchFactsCoordinatorDelegate {
    func backToHomeFacts(_ coordinator: ChuckNorrisSearchFactsCoordinator,
                         viewModel: ChuckNorrisSearchFactsViewModel, result: ChuckNorrisResultModel) {
        guard let homeFactsViewController = viewController as? HomeFactsViewController else { return }
        homeFactsViewController.viewModel.updateFactsList(with: result.result)
        homeFactsViewController.verifyLinkViewIfNeeded()
    }
}

