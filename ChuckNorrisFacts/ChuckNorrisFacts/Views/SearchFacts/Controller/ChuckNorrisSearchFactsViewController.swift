//
//  ChuckNorrisSearchFactsViewController.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 17/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

class ChuckNorrisSearchFactsViewController: UIViewController {
    
    // MARK: - Propeties
    
    var viewModel: ChuckNorrisSearchFactsViewModel!
    
    // MARK: - Initialize
    
    init(_ viewModel: ChuckNorrisSearchFactsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: Methods
    
    func setupNavigationBar() {
        title = "Pesquisa"
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.setHidesBackButton(false, animated: false)
    }

}
