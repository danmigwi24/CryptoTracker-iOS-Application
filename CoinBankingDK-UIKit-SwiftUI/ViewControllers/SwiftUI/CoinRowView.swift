//
//  CoinRowView.swift
//  CoinBankingDK-UIKit-SwiftUI
//
//  Created by Daniel Kimani on 26/04/2025.
//

// SwiftUI/CoinRowView.swift
import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        HStack {
            // Rank
            Text("\(coin.rank ?? 0)")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(minWidth: 30)
            
            // Icon
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
            .frame(width: 30, height: 30)
            
            // Name and Symbol
            VStack(alignment: .leading, spacing: 4) {
                Text(coin.name ?? "")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(coin.symbol ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 2)
            
            Spacer()
            
            // Price and Change
            VStack(alignment: .trailing, spacing: 4) {
                Text(coin.formattedPrice)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(coin.formattedChange)
                    .font(.caption)
                    .foregroundColor(coin.isPositiveChange ? .green : .red)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}
