//
//  HomeFactTableViewCell.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 20/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

// MARK: - Action Delegate

protocol HomeFactTableViewCellDelegate: AnyObject {
    func homeFactTableViewCell(_ cell: UITableViewCell,  shareButtonTapped button: UIButton)
}

class HomeFactTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    // MARK: - Delegate
    
    weak var delegate: HomeFactTableViewCellDelegate?
    
    // MARK: - Methods
    
    func fillCell(_ description: String, category: String) {
        descriptionLabel.text = description.uppercased()
        categoryLabel.text = category
    }
    
    func handlerFontDescriptionLabel(_ sizeFont: CGFloat) {
        descriptionLabel.font = UIFont.systemFont(ofSize: sizeFont)
    }
    
    // MARK: - Action
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        delegate?.homeFactTableViewCell(self, shareButtonTapped: sender)
    }
}
