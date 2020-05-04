//
//  UICollectionViewLayoutAttributes+Extension.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 25/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

extension UICollectionViewLayoutAttributes {
    
    /// Align left frame of sections in collectionView
    /// - Parameter sectionInset: UIEdgeInsets
    func leftAlignFrameWithSectionInset(_ sectionInset: UIEdgeInsets) {
        var frame = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
}
