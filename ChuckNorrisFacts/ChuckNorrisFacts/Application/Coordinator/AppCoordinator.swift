//
//  AppCoordinator.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 13/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    var childCoordinators: [BaseCoordinator]?
    var navigation: UINavigationController?
    var viewController: UIViewController?
    
    init() {
        let viewModel = HomeFactsViewModel()
        let viewController = HomeFactsViewController(viewModel)
        self.viewController = viewController
    }
    
    func stop() {
        childCoordinators = nil
        navigation = nil
        viewController = nil
    }
}
