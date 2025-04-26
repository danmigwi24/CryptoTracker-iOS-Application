//
//  CoinDetailViewController.swift
//  CoinBankingDK-UIKit-SwiftUI
//
//  Created by Daniel Kimani on 26/04/2025.
//

// ViewControllers/CoinDetailViewController.swift
import UIKit
import SwiftUI
import Combine

class CoinDetailViewController: UIViewController {
    private let coin: Coin
    private var hostingController: UIHostingController<CoinDetailView>?
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = coin.name
        view.backgroundColor = .systemBackground
        
        setupSwiftUIView()
    }
    
    private func setupSwiftUIView() {
        // Create and embed SwiftUI view
        let detailView = CoinDetailView(coin: coin)
        hostingController = UIHostingController(rootView: detailView)
        
        if let hostingController = hostingController {
            addChild(hostingController)
            
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(hostingController.view)
            
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
            
            hostingController.didMove(toParent: self)
        }
        
        /*
        // Add a favorite button to the navigation bar
        let isFavorite = FavoritesManager.shared.isFavorite(coinId: coin.id)
        let favoriteImage = UIImage(systemName: isFavorite ? "star.fill" : "star")
        let favoriteButton = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(toggleFavorite))
        favoriteButton.tintColor = .systemYellow
        navigationItem.rightBarButtonItem = favoriteButton
        
        // Listen for changes to update the favorite button
        FavoritesManager.shared.$favorites
            .sink { [weak self] _ in
                guard let self = self else { return }
                let isFavorite = FavoritesManager.shared.isFavorite(coinId: self.coin.id)
                let favoriteImage = UIImage(systemName: isFavorite ? "star.fill" : "star")
                self.navigationItem.rightBarButtonItem?.image = favoriteImage
            }
            .store(in: &cancellables)
        */
    }
    
    @objc private func toggleFavorite() {
        FavoritesManager.shared.toggleFavorite(coinId: coin.id)
    }
}





