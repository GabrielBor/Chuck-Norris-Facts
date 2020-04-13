//
//  BaseCoordinator.swift
//  ChuckNorris
//
//  Created by Gabriel Borges on 08/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

// MARK: - Type of presentations

enum TypePresentation {
    case present(_ navigation: UINavigationController)
    case push(_ navigation: UINavigationController)
}

// MARK: - BaseCoordinator

protocol BaseCoordinator: AnyObject {
    var childCoordinators: [BaseCoordinator]? { get set }
    var navigation: UINavigationController? { get set }
    var viewController: UIViewController? { get set }
    func start() -> UIViewController?
    func start(using presentation: TypePresentation, animated: Bool)
    func stop()
}

extension BaseCoordinator {
    
    /// This method is usage for call your viewController with two display mode
    /// - Parameters:
    ///   - presentation: present or push
    ///   - animated: animated display or not
    func start(using presentation: TypePresentation, animated: Bool) {
        switch presentation {
        case .present(let navigation):
            guard let viewController = viewController else { return }
            navigation.present(viewController, animated: animated, completion: nil)
        case .push(let navigation):
            guard let viewController = viewController else { return }
            navigation.pushViewController(viewController, animated: animated)
        }
    }
    
    /// This method return a viewController for start flow
    func start() -> UIViewController? {
        return viewController
    }
}
