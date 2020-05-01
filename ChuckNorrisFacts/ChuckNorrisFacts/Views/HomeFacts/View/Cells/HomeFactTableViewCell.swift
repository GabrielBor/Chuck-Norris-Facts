//
//  HomeFactTableViewCell.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 20/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeFactTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var factView: UIView!
    
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
        categoryLabel.cornerRadius(10, maskToBounds: true)
    }
    
    func setupFactViewShadow() {
        factView.cornerRadius(10, maskToBounds: false)
        factView.shadowAroundView(CGSize(width: 0, height: 0), color: .black, opacity: 0.23, shadowRadius: 4)
    }
}
