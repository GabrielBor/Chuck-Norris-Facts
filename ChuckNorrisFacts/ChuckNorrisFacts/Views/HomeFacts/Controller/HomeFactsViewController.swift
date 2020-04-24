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
        setTableViewDelegate()
        bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Register Cell
    
    func registerCell() {
        factsTableView.register(HomeFactTableViewCell.self, forCellReuseIdentifier: "HomeFactTableViewCell")
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
    
    func bindView() {
        if viewModel.factsList.isEmpty {
            let linkView = ChuckNorrisLinkView(frame: CGRect.zero)
            linkView.delegate = self
            view.addSubview(linkView)
            view.pinnedSubView(linkView)
        } else {
            viewModel.setupOnNextFactList()
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
    
    func factsTableViewDataSource() {
       viewModel.factsPublish.bind(to: factsTableView.rx.items(cellIdentifier: "HomeFactTableViewCell", cellType: HomeFactTableViewCell.self)) { (row, item, cell) in
        cell.delegate = self
        cell.fillCell(item.categories[row].description, category: item.categories[row])
        cell.handlerFontDescriptionLabel(self.viewModel.sizeFont(for: item.categories[row].description))
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
