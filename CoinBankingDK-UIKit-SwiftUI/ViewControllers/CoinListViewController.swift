//
//  CoinListViewController.swift
//  CoinBankingDK-UIKit-SwiftUI
//
//  Created by Daniel Kimani on 26/04/2025.
//

// ViewControllers/CoinListViewController.swift
import UIKit
import SwiftUI
import Combine

class CoinListViewController: UIViewController {
    private var coins: [Coin] = []
    private var filteredCoins: [Coin] = []
    private var currentPage = 0
    private let pageSize = 20
    private var isFiltering = false
    private var sortOption: SortOption = .rank
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = CryptoViewModel()
    
    enum SortOption {
        case rank
        case price
        case change
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: "CoinCell")
        tableView.rowHeight = 80
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Rank", "Price", "24h Change"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        loadCoins()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        loadCoins()
    }
    
    private func setupUI() {
        title = "Top 100 Coins"
        view.backgroundColor = .systemBackground
        
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            //
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            //
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        // Listen for changes in favorites
        FavoritesViewModels.shared.$favorites
            .sink { [weak self] _ in
                // When favorites change, reload relevant cells
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func loadCoins() {
        activityIndicator.startAnimating()
        
        /*
        viewModel.fetchCoinsPublisher { status, message, response in
            self.activityIndicator.stopAnimating()
            if status{
                if self.currentPage == 0 {
                    self.coins = response?.data?.coins ?? []
                } else {
                    self.coins.append(contentsOf: response?.data?.coins ?? [])
                }
                self.applySort()
                self.tableView.reloadData()
                
            }else{
                self.showAlert(title: "Error", message: message)
            }
        }
         */
        
        APIService.shared.fetchCoins(offset: currentPage * pageSize, limit: pageSize) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let response):
                    if self.currentPage == 0 {
                        self.coins = response.data?.coins ?? []
                    } else {
                        self.coins.append(contentsOf: response.data?.coins ?? [])
                    }
                    self.applySort()
                    self.tableView.reloadData()
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
      
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sortOption = .rank
        case 1:
            sortOption = .price
        case 2:
            sortOption = .change
        default:
            sortOption = .rank
        }
        
        applySort()
        tableView.reloadData()
    }
    
    private func applySort() {
        switch sortOption {
        case .rank:
            coins.sort { $0.rank ?? 0 < $1.rank ?? 0 }
        case .price:
            coins.sort { $0.priceAsDouble > $1.priceAsDouble }
        case .change:
            coins.sort { $0.changeAsDouble > $1.changeAsDouble }
        }
    }
}

extension CoinListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredCoins.count : coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        
        let coin = isFiltering ? filteredCoins[indexPath.row] : coins[indexPath.row]
        cell.configure(with: coin)
        
        // Load more coins when reaching end of the list
        if !isFiltering && indexPath.row == coins.count - 5 && coins.count < 100 {
            currentPage += 1
            loadCoins()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let coin = isFiltering ? filteredCoins[indexPath.row] : coins[indexPath.row]
        let detailVC = CoinDetailViewController(coin: coin)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let coin = isFiltering ? filteredCoins[indexPath.row] : coins[indexPath.row]
        let isFavorite = FavoritesViewModels.shared.isFavorite(coinId: coin.uuid ?? "")
        
        let title = isFavorite ? "Unfavorite" : "Favorite"
        let favoriteAction = UIContextualAction(style: .normal, title: title) { (action, view, completion) in
            FavoritesViewModels.shared.toggleFavorite(coinId: coin.uuid ?? "")
            completion(true)
        }
        
        favoriteAction.backgroundColor = isFavorite ? .systemRed : .systemYellow
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
}


///*
 // Adding search functionality to CoinListViewController.swift
 // Add this extension to CoinListViewController

// Update the viewDidLoad method in CoinListViewController to include search functionality
// Add this line to the setupUI method:
//   setupSearchController()

 extension CoinListViewController: UISearchResultsUpdating, UISearchBarDelegate {
     func setupSearchController() {
         let searchController = UISearchController(searchResultsController: nil)
         searchController.searchResultsUpdater = self
         searchController.obscuresBackgroundDuringPresentation = false
         searchController.searchBar.placeholder = "Search Coins"
         navigationItem.searchController = searchController
         navigationItem.hidesSearchBarWhenScrolling = false
         definesPresentationContext = true
         
         searchController.searchBar.delegate = self
     }
     
     func updateSearchResults(for searchController: UISearchController) {
         guard let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty else {
             isFiltering = false
             tableView.reloadData()
             return
         }
         
         isFiltering = true
         filteredCoins = coins.filter { coin in
             return coin.name?.lowercased().contains(searchText) ?? false ||
             coin.symbol?.lowercased().contains(searchText) ?? false
         }
         
         tableView.reloadData()
     }
     
     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         isFiltering = false
         tableView.reloadData()
     }
 }
 //*/
