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
    @IBOutlet weak var suggestionCollectionView: UICollectionView!
    @IBOutlet weak var lastSearchesLabel: UILabel!
    @IBOutlet weak var lastSearchTableView: UITableView!
    @IBOutlet weak var factsSearchBar: UISearchBar!
    
    // MARK: - Propeties
    
    var loadView = LoadView()
    var viewModel: ChuckNorrisSearchFactsViewModel!
    var disposeBag = DisposeBag()
    var minimumLineSpacingForSection: CGFloat = 8
    var minimumInterItemSpacingForSection: CGFloat = 8
    var suggestionIdentifier = IdentifierCell.suggestionCollectionCell.rawValue
    var pastSearchIdentifier = IdentifierCell.pastSearchTableViewCell.rawValue
    
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
        searchBarSearchButtonClicked()
        loadingPublish()
        bindCollectionViewSuggestions()
        bindTableViewPastSearch()
        emptySearchResultPublish()
        setDelegate()
        viewModel.fetchRuleSuggestions()
        viewModel.loadLastSearches()
        showLastSearchesList()
    }
    
    // MARK: - SetDelegate
    
    func setDelegate() {
        lastSearchTableView.rx.setDelegate(self).disposed(by: disposeBag)
        suggestionCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    // MARK: Methods
    
    func registerCells() {
        let suggestionNib = UINib(nibName: suggestionIdentifier, bundle: nil)
        let pastSearchNib = UINib(nibName: pastSearchIdentifier, bundle: nil)
        suggestionCollectionView.register(suggestionNib, forCellWithReuseIdentifier: suggestionIdentifier)
        lastSearchTableView.register(pastSearchNib, forCellReuseIdentifier: pastSearchIdentifier)
    }
    
    func setupNavigationBar() {
        title = "Search"
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func heightSuggestionsCollectionView() {
        let height = suggestionCollectionView.collectionViewLayout.collectionViewContentSize.height
        heightSuggestionsConstraint.constant = height
        view.layoutIfNeeded()
    }
    
    func showLastSearchesList() {
        viewModel.listLastSearhcesRelay.asObservable().observeOn(MainScheduler.instance).subscribe { (event) in
            let isHidden = event.element?.isEmpty ?? true
            self.lastSearchesLabel.isHidden = isHidden
            self.lastSearchTableView.isHidden = isHidden
        }.disposed(by: disposeBag)
    }
    
    // MARK: - BindCollectionViewSuggestions
    
    func bindCollectionViewSuggestions() {
        collectionViewDataSource()
        didSelectItem()
        setupAfterBindHeightCollectionView()
        errorPublish()
    }
    
    // MARK: - BindTableViewPastSearch
    
    func bindTableViewPastSearch() {
        tableViewDataSource()
        didSelectRow()
    }
}

// MARK: - EmptySearchResult Alert

extension ChuckNorrisSearchFactsViewController {
    func emptySearchResultPublish() {
        viewModel.emptySearchResultPublish.asObservable().observeOn(MainScheduler.instance).subscribe { [weak self] (event) in
            guard let self = self else { return }
            let alert = UIAlertController.createSimpleAlert(with: AlertTexts.emptyTitle.rawValue,
                                                            message: AlertTexts.emptyMessage.rawValue,
                                                            style: .alert,
                                                            titleAction: "Ok",
                                                            actionAlert: {
                                                                self.factsSearchBar.text = ""
            })
            self.present(alert, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}

// MARK: - Comon

extension ChuckNorrisSearchFactsViewController {
    
    func loadingPublish() {
        viewModel.loadingBehaviorRelay.asObservable().observeOn(MainScheduler.instance).subscribe { [weak self] (event) in
            guard let self = self else { return }
            let isShow = event.element ?? false
            self.loadView.showLoading(isShow, atView: self.navigationController?.view)
        }.disposed(by: disposeBag)
    }
    
    func errorPublish() {
        viewModel.errorPublishSubject.asObservable().observeOn(MainScheduler.instance).subscribe { [weak self] (event) in
            guard let self = self else { return }
            let code = event.element?.code ?? 0
            let errorMessage = event.element?.message ?? ""
            let message = "\(AlertTexts.errorMessage.rawValue)\(code) \(errorMessage)"
            let alert = UIAlertController.createSimpleAlert(with: AlertTexts.errorTitle.rawValue,
                                                            message: message,
                style: .alert,
                titleAction: "Ok",
                actionAlert: {
                    self.factsSearchBar.text = ""
            })
            self.present(alert, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}

// MARK: - ColectionViewDataSource

extension ChuckNorrisSearchFactsViewController {
    
    func collectionViewDataSource() {
        
        viewModel.listSuggestionBehaviorRelay
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: suggestionCollectionView.rx.items(cellIdentifier: suggestionIdentifier, cellType: ChuckNorrisCategoryCollectionViewCell.self)) { (row, item, cell) in
            cell.fillCell(item)
        }.disposed(by: disposeBag)
    }
    
    func setupAfterBindHeightCollectionView() {
        
        viewModel.listSuggestionBehaviorRelay.asObservable().observeOn(MainScheduler.instance).subscribe { (_) in
            self.heightSuggestionsCollectionView()
        }.disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegate

extension ChuckNorrisSearchFactsViewController {
    
    func didSelectItem() {
        suggestionCollectionView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.viewModel.fetchSearchCategoryFacts(from: text.lowercased())
            }).disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChuckNorrisSearchFactsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize.init(width: 200, height: 25)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let str = viewModel.listSuggestionBehaviorRelay.value[indexPath.item]
        
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

// MARK: - UITableViewDataSource

extension ChuckNorrisSearchFactsViewController {
    
    func tableViewDataSource() {
        viewModel.listLastSearhcesRelay.bind(to: lastSearchTableView.rx.items(cellIdentifier: pastSearchIdentifier, cellType: ChuckNorrisPastSearchTableViewCell.self)) { (row, item, cell) in
            cell.fillCell(item)
        }.disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension ChuckNorrisSearchFactsViewController: UITableViewDelegate {
    
    func didSelectRow() {
        lastSearchTableView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.viewModel.fetchSearchCategoryFacts(from: text.lowercased())
            }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UISearchBarDelegate

extension ChuckNorrisSearchFactsViewController {
    
    func searchBarSearchButtonClicked() {
        factsSearchBar.rx
            .searchButtonClicked
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] (event) in
                guard let self = self else { return }
                self.view.endEditing(true)
                guard let text = self.factsSearchBar.text, !text.isEmpty else {
                    let alert = UIAlertController.createSimpleAlert(with: AlertTexts.emptyTitle.rawValue,
                                                                    message: AlertTexts.notEmptyMessage.rawValue,
                                                                    style: .alert,
                                                                    titleAction: "Ok",
                                                                    actionAlert: nil)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.viewModel.saveLastSearch(text)
                self.viewModel.fetchSearchCategoryFacts(from: text.lowercased())
        }.disposed(by: disposeBag)
    }
}
