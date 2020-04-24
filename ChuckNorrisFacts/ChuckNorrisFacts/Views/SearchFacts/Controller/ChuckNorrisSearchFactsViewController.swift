//
//  ChuckNorrisSearchFactsViewController.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 17/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChuckNorrisSearchFactsViewController: UIViewController {
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var suggestionCollecitonView: UICollectionView!
    @IBOutlet weak var pastSearchTableView: UITableView!
    
    // MARK: - Propeties
    
    var viewModel: ChuckNorrisSearchFactsViewModel!
    var disposeBag = DisposeBag()
    
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
        setupNavigationBar()
        registerCells()
        setDelegate()
        bindView()
        viewModel.fetchListSuggestionFacts()
    }
    
    // MARK: - TableViewSetDelegate
    
    func setDelegate() {
        pastSearchTableView.rx.setDelegate(self).disposed(by: disposeBag)
        suggestionCollecitonView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    // MARK: - BindView
    
    func bindView() {
        // TODO: fazer o loading
        
        // Success
        viewModel.listSuggestionPublish
        .asObserver()
        .observeOn(MainScheduler.instance)
        .bind(to: suggestionCollecitonView.rx.items(cellIdentifier: "ChuckNorrisCategoryCollectionViewCell", cellType: ChuckNorrisCategoryCollectionViewCell.self)) { (row, item, cell) in
            cell.fillCell(item)
        }.disposed(by: disposeBag)
        
        // Error
        viewModel
        .error
        .observeOn(MainScheduler.instance)
        .subscribe { (error) in
            // TODO: pop de error aqui
        }.disposed(by: disposeBag)
    }
    
    // MARK: Methods
    
    func registerCells() {
        suggestionCollecitonView.register(ChuckNorrisCategoryCollectionViewCell.self,
                                          forCellWithReuseIdentifier: "ChuckNorrisCategoryCollectionViewCell")
    }
    
    func setupNavigationBar() {
        title = "Pesquisa"
        self.navigationItem.setHidesBackButton(false, animated: false)
        navigationItem.searchController = createSearchController()
    }
    
    func createSearchController() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        return searchController
    }
}

// MARK: - UITableViewDelegate

extension ChuckNorrisSearchFactsViewController: UITableViewDelegate {
    
}

// MARK: - UICollectionViewDelegate

extension ChuckNorrisSearchFactsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

// MARK: - UISearchResultsUpdating

extension ChuckNorrisSearchFactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
