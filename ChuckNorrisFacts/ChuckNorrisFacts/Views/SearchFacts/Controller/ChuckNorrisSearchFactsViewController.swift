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
    
    @IBOutlet weak var heightSuggestionsConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestionCollecitonView: UICollectionView!
    @IBOutlet weak var pastSearchTableView: UITableView!
    
    // MARK: - Propeties
    
    var viewModel: ChuckNorrisSearchFactsViewModel!
    var disposeBag = DisposeBag()
    var minimumLineSpacingForSection: CGFloat = 8
    var minimumInterItemSpacingForSection: CGFloat = 8
    var suggestionIdentifier = IdentifierCell.suggestion.rawValue
    var pastSearchIdentifier = IdentifierCell.pastSearch.rawValue
    
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
        bindView()
        setDelegate()
        viewModel.fetchRuleSuggestions()
    }
    
    // MARK: - TableViewSetDelegate
    
    func setDelegate() {
//        pastSearchTableView.rx.setDelegate(self).disposed(by: disposeBag)
        suggestionCollecitonView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    // MARK: Methods
    
    func registerCells() {
        let suggestionNib = UINib(nibName: suggestionIdentifier, bundle: nil)
//        let pastSearchNib = UINib(nibName: pastSearchIdentifier, bundle: nil)
        suggestionCollecitonView.register(suggestionNib, forCellWithReuseIdentifier: suggestionIdentifier)
//        pastSearchTableView.register(pastSearchNib, forCellReuseIdentifier: pastSearchIdentifier)
    }
    
    func setupNavigationBar() {
        title = "Pesquisa"
        self.navigationItem.setHidesBackButton(false, animated: false)
        navigationItem.searchController = createSearchController()
    }
    
    func heightSuggestionsCollectionView() {
        let height = suggestionCollecitonView.collectionViewLayout.collectionViewContentSize.height
        heightSuggestionsConstraint.constant = height
        view.layoutIfNeeded()
    }
    
    func createSearchController() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        return searchController
    }
    
    // MARK: - BindView
    
    func bindView() {
        bindLoading()
        bindSuggestionColelctionView()
        setupAfterBindHeightCollectionView()
        bindError()
    }
    
    func bindLoading() {
        // TODO: fazer o loading
    }
    
    func bindSuggestionColelctionView() {
        viewModel.listSuggestionPublish
            .asObserver()
            .observeOn(MainScheduler.instance)
            .bind(to: suggestionCollecitonView.rx.items(cellIdentifier: suggestionIdentifier, cellType: ChuckNorrisCategoryCollectionViewCell.self)) { (row, item, cell) in
                cell.fillCell(item)
        }.disposed(by: disposeBag)
    }
    
    func setupAfterBindHeightCollectionView() {
        _ = viewModel.listSuggestionPublish.subscribe {
            self.heightSuggestionsCollectionView()
        }
    }
    
    func bindError() {
        viewModel
            .error
            .asObserver()
            .observeOn(MainScheduler.instance)
            .subscribe { (error) in
                // TODO: pop de error aqui
        }.disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension ChuckNorrisSearchFactsViewController: UITableViewDelegate {
    
}

// MARK: - UICollectionViewDelegate

extension ChuckNorrisSearchFactsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tocou")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChuckNorrisSearchFactsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize.init(width: 200, height: 25)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        guard let str = try? viewModel.listSuggestionPublish.value()[indexPath.item] else { return CGSize() }

        let estimatedRect = NSString.init(string: str).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 28)], context: nil)

        return CGSize.init(width: estimatedRect.size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterItemSpacingForSection
    }
}

// MARK: - UISearchResultsUpdating

extension ChuckNorrisSearchFactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
