//
//  CryptoViewModel.swift
//  CoinBankingDK-UIKit-SwiftUI
//
//  Created by Daniel Kimani on 26/04/2025.
//

import Foundation
import Combine

class CryptoViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var filteredCoins: [Coin] = []
    @Published var currentPage = 0
    @Published var pageSize = 20
    @Published var isFiltering = false
    @Published var sortOption: SortOption = .rank

    enum SortOption {
        case rank
        case price
        case change
    }
    

    private var cancellables = Set<AnyCancellable>()
    
    //MARK: fetchCoinsPublisher
    func fetchCoinsPublisher(offset: Int = 0, limit: Int = 20, handleCompletion: @escaping (Bool, String ,CoinResponse?) -> Void){
        
        APIService.shared.fetchCoinsPublisher(offset: offset, limit: limit)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                
                if case .failure(let error) = completion {
                    handleCompletion(false ,"Failed to fetch data", nil)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                //
                if response.status == "success"{
                    self.coins = response.data?.coins ?? []
                    handleCompletion(true,"Data fetched successfully" , response)
                }else{
                    handleCompletion(false ,"Failed to fetch data", nil)
                }
                //
            }
            .store(in: &cancellables)
    }

    
    func setupBindings(handleCompletion: @escaping () -> Void) {
        // Listen for changes in favorites
        FavoritesViewModels.shared.$favorites
            .sink { _ in
                // When favorites change, reload relevant cells
                //self?.tableView.reloadData()
                handleCompletion()
            }
            .store(in: &cancellables)
    }
   
     func applySort() {
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
