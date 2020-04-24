//
//  ChuckNorrisCategoryCollectionViewCell.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 23/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

class ChuckNorrisCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    func fillCell(_ category: String) {
        categoryLabel.text = category
    }
}
