//
//  ChuckNorrisPastSearchTableViewCell.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 23/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

class ChuckNorrisPastSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lastSearchLabel: UILabel!
    
    func fillCell(_ pastWord: String) {
        lastSearchLabel.text = pastWord
    }
    
    func textCell() -> String {
        return lastSearchLabel.text ?? ""
    }
}
