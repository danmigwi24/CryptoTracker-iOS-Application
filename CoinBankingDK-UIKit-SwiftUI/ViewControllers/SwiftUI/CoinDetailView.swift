//
//  CoinDetailVieww.swift
//  CoinBankingDK-UIKit-SwiftUI
//
//  Created by Daniel Kimani on 26/04/2025.
//


// SwiftUI/CoinDetailView.swift
import SwiftUI

struct CoinDetailView: View {
    let coin: Coin
    @ObservedObject private var favoritesManager = FavoritesViewModels.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header with icon and name
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: coin.iconUrl ?? "")) { phase in
                        if let image = phase.image {
                            image.resizable().scaledToFit()
                        } else if phase.error != nil {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.gray)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(coin.name ?? "")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(coin.symbol ?? "")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        favoritesManager.toggleFavorite(coinId: coin.id)
                    }) {
                        Image(systemName: favoritesManager.isFavorite(coinId: coin.id) ? "star.fill" : "star")
                            .font(.title2)
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.horizontal)
                
                // Price and change
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current Price")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(coin.formattedPrice)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 8) {
                        Text("24h Change")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(coin.formattedChange)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(coin.isPositiveChange ? .green : .red)
                    }
                }
                .padding(.horizontal)
                
                // Performance chart
                VStack(alignment: .leading, spacing: 8) {
                   
                    // Chart title
                    Text("\(coin.name ?? "") Performance : Price (24h)")
                        .foregroundColor(.primary)
                        .font(.headline)
                        .padding(.horizontal)
                    
                    //PriceChartView(sparklineData: coin.sparkline ?? [])
                    CoinChartView(coin: coin)
                        .frame(height: 250)
                }
                
                // Additional statistics
                VStack(alignment: .leading, spacing: 12) {
                    Text("Statistics")
                        .font(.headline)
                    
                    Group {
                        HStack {
                            Text("Rank")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("#\(coin.rank ?? 0)")
                                .fontWeight(.medium)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Market Cap")
                                .foregroundColor(.secondary)
                            Spacer()
                            
                            let marketCap = Double(coin.marketCap ?? "") ?? 0
                            Text(formatLargeNumber(marketCap))
                                .fontWeight(.medium)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
    }
    
    private func formatLargeNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        if value >= 1_000_000_000 {
            formatter.positiveSuffix = "B"
            return formatter.string(from: NSNumber(value: value / 1_000_000_000)) ?? "$0"
        } else if value >= 1_000_000 {
            formatter.positiveSuffix = "M"
            return formatter.string(from: NSNumber(value: value / 1_000_000)) ?? "$0"
        } else {
            return formatter.string(from: NSNumber(value: value)) ?? "$0"
        }
    }
}
