//
//  HomeFactsViewController.swift
//  ChuckNorris
//
//  Created by Gabriel Borges on 12/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

class HomeFactsViewController: UIViewController {
    
    // MARK: - IBOutlet Property
    
    @IBOutlet weak var factsTableView: UITableView!
    
    // MARK: - Property
    
    var viewModel: HomeFactsViewModel!
    
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
        setupChuckNorrisLinkView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: Methods
    
    func setupNavigationBar() {
        title = "Chuck Norris"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        navigationItem.searchController = createSearchController()
    }
    
    func setupChuckNorrisLinkView() {
        if viewModel.factsList.isEmpty {
            let linkView = ChuckNorrisLinkView(frame: CGRect.zero)
            linkView.delegate = self
            view.addSubview(linkView)
            linkView.translatesAutoresizingMaskIntoConstraints = false
            linkView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            linkView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            linkView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            linkView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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

//MARK: - UITableViewDataSource

extension HomeFactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.factsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFactTableViewCell", for: indexPath) as? HomeFactTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.fillCell(viewModel.factsList[indexPath.row].description,
                      category: viewModel.factsList[indexPath.row].categories[indexPath.row])
        cell.handlerFontDescriptionLabel(viewModel.sizeFont(for: viewModel.factsList[indexPath.row].description))
        return cell
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
