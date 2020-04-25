//
//  ChuckNorrisPastSearchTableViewCell.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 23/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

class ChuckNorrisPastSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pastWordLabel: UILabel!
    
    func fillCell(_ pastWord: String) {
        pastWordLabel.text = pastWord
    }
}
