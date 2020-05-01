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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        searchTapped()
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
    
    func share(_ fact: String) {
        let activityViewController = UIActivityViewController(activityItems: [fact], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    func searchTapped() {
        navigationItem.rightBarButtonItem?.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel.goToSearchFacts()
        }.disposed(by: disposeBag)
    }
    
    func sharedFactTapped(from cell: HomeFactTableViewCell, urlString: String) {
        cell.shareButton.rx.tap
        .bind { [weak self] in
            guard let self = self else { return }
            self.share(urlString)
        }
        .disposed(by: disposeBag)
    }
}

//MARK: - TableViewRxDataSource

extension HomeFactsViewController  {
    
    func tableViewDataSource() {
        viewModel.factsPublish.bind(to: factsTableView.rx.items(cellIdentifier: homeFactsIdentifier, cellType: HomeFactTableViewCell.self)) { (row, item, cell) in
            cell.fillCell(item.description, category: self.viewModel.setUncategorizedIfNeeded(item.categories.first))
            cell.handlerFontDescriptionLabel(self.viewModel.sizeFont(for: item.description))
            self.sharedFactTapped(from: cell, urlString: item.url)
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
