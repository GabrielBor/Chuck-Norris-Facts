//
//  ChuckNorrisPastSearchTableViewCell.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 23/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

class ChuckNorrisPastSearchTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lastSearchLabel: UILabel!
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupContainerViewShadow()
    }
    
    // MARK: - Methods
    
    func fillCell(_ pastWord: String) {
        lastSearchLabel.text = pastWord
    }

    func setupContainerViewShadow() {
        containerView.cornerRadius(10, maskToBounds: false)
        containerView.shadowAroundView(CGSize(width: 0, height: 0), color: .black, opacity: 0.23, shadowRadius: 4)
    }
}
