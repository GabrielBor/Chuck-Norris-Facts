//
//  UIView+Extension.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 21/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

extension UIView {
    
    func pinnedSubView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func cornerRadius(_ cornerRadius: CGFloat, maskToBounds: Bool) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = maskToBounds
    }
    
    func shadowAroundView(_ size: CGSize, color: UIColor, opacity: Float, shadowRadius: CGFloat) {
        self.layer.shadowOffset = size
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
    }
}
