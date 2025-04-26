//
//  FavoritesViewModels.swift
//  CoinBankingDK-UIKit
//
//  Created by Daniel Kimani on 26/04/2025.
//

// Services/FavoritesViewModels.swift
import Foundation
import Combine

class FavoritesViewModels: ObservableObject {
    static let shared = FavoritesViewModels()
    
    private let favoritesKey = "favoritedCoins"
    
    @Published private(set) var favorites: [String] = []
    
    private init() {
        favorites = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
    }
    
    func getFavorites() -> [String] {
        return favorites
    }
    
    func addFavorite(coinId: String) {
        if !favorites.contains(coinId) {
            favorites.append(coinId)
            UserDefaults.standard.set(favorites, forKey: favoritesKey)
        }
    }
    
    func removeFavorite(coinId: String) {
        if let index = favorites.firstIndex(of: coinId) {
            favorites.remove(at: index)
            UserDefaults.standard.set(favorites, forKey: favoritesKey)
        }
    }
    
    func isFavorite(coinId: String) -> Bool {
        return favorites.contains(coinId)
    }
    
    func toggleFavorite(coinId: String) {
        if isFavorite(coinId: coinId) {
            removeFavorite(coinId: coinId)
        } else {
            addFavorite(coinId: coinId)
        }
    }
}

