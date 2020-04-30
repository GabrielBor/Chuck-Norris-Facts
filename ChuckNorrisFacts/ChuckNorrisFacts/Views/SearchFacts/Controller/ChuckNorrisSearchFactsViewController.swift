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
        loadingPublish()
        bindCollectionViewSuggestions()
        bindTableViewPastSearch()
        emptySearchResultPublish()
        setDelegate()
        viewModel.fetchRuleSuggestions()
        viewModel.loadLastSearches()
    }
    
    // MARK: - TableViewSetDelegate
    
    func setDelegate() {
        pastSearchTableView.rx.setDelegate(self).disposed(by: disposeBag)
        suggestionCollecitonView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    // MARK: Methods
    
    func registerCells() {
        let suggestionNib = UINib(nibName: suggestionIdentifier, bundle: nil)
        let pastSearchNib = UINib(nibName: pastSearchIdentifier, bundle: nil)
        suggestionCollecitonView.register(suggestionNib, forCellWithReuseIdentifier: suggestionIdentifier)
        pastSearchTableView.register(pastSearchNib, forCellReuseIdentifier: pastSearchIdentifier)
    }
    
    func setupNavigationBar() {
        title = "Pesquisa"
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func heightSuggestionsCollectionView() {
        let height = suggestionCollecitonView.collectionViewLayout.collectionViewContentSize.height
        heightSuggestionsConstraint.constant = height
        view.layoutIfNeeded()
    }
    
    // MARK: - BindCollectionSuggestions
    
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
        viewModel.emptySearchResultPublish.asObserver().observeOn(MainScheduler.instance).subscribe { [weak self] (_) in
            guard let self = self else { return }
            let alert = UIAlertController.createSimpleAlert(with: "Ops!",
                                                            message: "Parece que não encontramos nada a respeito da sua pesquisa. ;(",
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
        viewModel.loadingRelay.asObservable().observeOn(MainScheduler.instance).subscribe { (event) in
            let isShow = event.element ?? false
            self.loadView.showLoading(isShow, atView: self.navigationController?.view)
        }.disposed(by: disposeBag)
    }
    
    func errorPublish() {
        viewModel.errorPublish.asObserver().observeOn(MainScheduler.instance).subscribe { [weak self] (error) in
            guard let self = self else { return }
            let code = error.event.element?.code ?? 0
            let message = error.event.element?.message ?? ""
            let alert = UIAlertController.createSimpleAlert(with: "Ops!",
                                                            message: "\(code) - \(message)",
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
}

// MARK: - UICollectionDelegate

extension ChuckNorrisSearchFactsViewController {
    
    func didSelectItem() {
        suggestionCollecitonView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let self = self,
                let cell = self.suggestionCollecitonView.cellForItem(at: indexPath) as? ChuckNorrisCategoryCollectionViewCell else { return }
            self.view.endEditing(true)
            let suggestion = cell.categoryLabel.text?.lowercased() ?? ""
            self.viewModel.fetchSearchCategoryFacts(from: suggestion)
        }).disposed(by: disposeBag)
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

// MARK: - UITableViewDataSource

extension ChuckNorrisSearchFactsViewController {
    
    func tableViewDataSource() {
        viewModel.listLastSearhcesRelay.bind(to: pastSearchTableView.rx.items(cellIdentifier: pastSearchIdentifier, cellType: ChuckNorrisPastSearchTableViewCell.self)) { (row, item, cell) in
                cell.fillCell(item)
        }.disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension ChuckNorrisSearchFactsViewController: UITableViewDelegate {
    
    func didSelectRow() {
        pastSearchTableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let self = self,
                let cell = self.pastSearchTableView.dequeueReusableCell(withIdentifier: self.pastSearchIdentifier, for: indexPath) as? ChuckNorrisPastSearchTableViewCell else { return }
            let suggestion = cell.pastWordLabel.text?.lowercased() ?? ""
            self.viewModel.fetchSearchCategoryFacts(from: suggestion)
        }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UISearchBarDelegate

extension ChuckNorrisSearchFactsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let text = searchBar.text else { return }
        viewModel.saveLastSearch(text)
        viewModel.fetchSearchCategoryFacts(from: text.lowercased())
    }
}
