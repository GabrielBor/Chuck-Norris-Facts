//
//  HomeFactsViewController.swift
//  ChuckNorris
//
//  Created by Gabriel Borges on 12/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeFactsViewController: UIViewController {
    
    // MARK: - IBOutlet Property
    
    @IBOutlet weak var factsTableView: UITableView!
    
    // MARK: - Property
    
    var viewModel: HomeFactsViewModel!
    var disposeBag = DisposeBag()
    var homeFactsIdentifier = IdentifierCell.homeFactsTableViewCell.rawValue
    var linkView = ChuckNorrisLinkView(frame: CGRect.zero)
    
    // MARK: - Initialize
    
    init(_ viewModel: HomeFactsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        tableViewDataSource()
        setTableViewDelegate()
        verifyLinkViewIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.clearFactsList()
    }
    
    // MARK: - Register Cell
    
    func registerCell() {
        let homeFactsCellNib = UINib(nibName: homeFactsIdentifier, bundle: nil)
        factsTableView.register(homeFactsCellNib, forCellReuseIdentifier: homeFactsIdentifier)
    }
    
    // MARK: - TableViewSetDelegate
    
    func setTableViewDelegate() {
        factsTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    
    func setupNavigationBar() {
        title = "Chuck Norris"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        navigationItem.searchController = !viewModel.factsList.isEmpty ? createSearchController() : nil
    }
    
    func verifyLinkViewIfNeeded() {
        if viewModel.factsList.isEmpty {
            linkView.delegate = self
            view.addSubview(linkView)
            view.pinnedSubView(linkView)
        } else {
            linkView.removeFromSuperview()
        }
    }
    
    func createSearchController() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        return searchController
    }
    
    // MARK: - Action
    
    @objc func searchTapped() {
        viewModel.goToSearchFacts()
    }
}

//MARK: - TableViewRxDataSource

extension HomeFactsViewController  {
    
    func tableViewDataSource() {
        viewModel.factsPublish.bind(to: factsTableView.rx.items(cellIdentifier: homeFactsIdentifier, cellType: HomeFactTableViewCell.self)) { (row, item, cell) in
            cell.delegate = self
            cell.fillCell(item.description, category: self.viewModel.setUncategorizedIfNeeded(item.categories.first))
            cell.handlerFontDescriptionLabel(self.viewModel.sizeFont(for: item.description))
        }.disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension HomeFactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - ChuckNorrisLinkViewDelegate

extension HomeFactsViewController: ChuckNorrisLinkViewDelegate {
    func linkView(_ view: ChuckNorrisLinkView, linkAction sender: UIButton) {
        viewModel.goToSearchFacts()
    }
}

// MARK: - HomeFactTableViewCellDelegate

extension HomeFactsViewController: HomeFactTableViewCellDelegate {
    func homeFactTableViewCell(_ cell: UITableViewCell, shareButtonTapped button: UIButton) {
        // TODO: fazer a parte de compartilhamento
    }
}

extension HomeFactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
