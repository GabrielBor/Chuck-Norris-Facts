//
//  ChuckNorrisLinkView.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 20/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

protocol ChuckNorrisLinkViewDelegate: AnyObject {
    func linkView(_ view: ChuckNorrisLinkView, linkAction sender: UIButton)
}

class ChuckNorrisLinkView: UIView {
    
    // MARK: - Properties IBOutlet
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    //MARK: - Delegate
    
    weak var delegate: ChuckNorrisLinkViewDelegate?
    
    // MARK: Initialized
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ChuckNorrisLinkView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: Action
    
    @IBAction func linkButtonTapped(_ sender: UIButton) {
        delegate?.linkView(self, linkAction: sender)
    }
}