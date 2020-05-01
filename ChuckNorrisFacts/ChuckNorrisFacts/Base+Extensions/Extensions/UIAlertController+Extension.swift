//
//  UIAlertController+Extension.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 26/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func createSimpleAlert(with title: String,
                            message: String,
                            style: UIAlertController.Style,
                            titleAction: String, actionAlert: (() -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: titleAction, style: .default, handler: { action in
            switch action.style {
            case .default:
                actionAlert?()
            default:
                break
            }}))
        return alert
    }
}
