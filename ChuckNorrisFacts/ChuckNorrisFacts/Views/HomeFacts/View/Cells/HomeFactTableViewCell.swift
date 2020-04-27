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
    @IBOutlet weak var factView: UIView!
    
    // MARK: - Delegate
    
    weak var delegate: HomeFactTableViewCellDelegate?
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFactViewShadow()
        setupCategoryLabelCornerRadius()
    }
    
    // MARK: - Methods
    
    func fillCell(_ description: String, category: String) {
        descriptionLabel.text = description
        categoryLabel.text = " \(category.uppercased())  "
        categoryLabel.textAlignment = .center
    }
    
    func handlerFontDescriptionLabel(_ sizeFont: CGFloat) {
        descriptionLabel.font = UIFont.systemFont(ofSize: sizeFont)
    }
    
    func setupCategoryLabelCornerRadius() {
        categoryLabel.layer.cornerRadius = 10
        categoryLabel.layer.masksToBounds = true
    }
    
    func setupFactViewShadow() {
        factView.layer.cornerRadius = 10
        factView.layer.masksToBounds = false
        factView.layer.shadowOffset = CGSize(width: 0, height: 0)
        factView.layer.shadowColor = UIColor.black.cgColor
        factView.layer.shadowOpacity = 0.23
        factView.layer.shadowRadius = 4
    }
    
    // MARK: - Action
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        delegate?.homeFactTableViewCell(self, shareButtonTapped: sender)
    }
}
