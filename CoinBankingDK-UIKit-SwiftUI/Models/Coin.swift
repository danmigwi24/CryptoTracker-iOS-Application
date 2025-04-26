//
//  CoinResponse.swift
//  CoinBankingDK-UIKit-SwiftUI
//
//  Created by Daniel Kimani on 26/04/2025.
//

import Foundation





// MARK: - CoinResponse
public struct CoinResponse: Codable, Hashable {
    public var status: String?
    public var data: DataClass?

    public enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }

    public init(status: String?, data: DataClass?) {
        self.status = status
        self.data = data
    }
}

// MARK: - DataClass
public struct DataClass: Codable, Hashable {
    public var stats: Stats?
    public var coins: [Coin]?

    public enum CodingKeys: String, CodingKey {
        case stats = "stats"
        case coins = "coins"
    }

    public init(stats: Stats?, coins: [Coin]?) {
        self.stats = stats
        self.coins = coins
    }
}

// MARK: - Coin
public struct Coin: Codable, Hashable {
    public var uuid: String?
    public var coinrankingUrl: String?
    public var listedAt: Int?
    public var the24HVolume: String?
    public var symbol: String?
    public var tier: Int?
    public var change: String?
    public var color: String?
    public var price: String?
    public var rank: Int?
    public var sparkline: [String?]?
    public var btcPrice: String?
    public var iconUrl: String?
    public var lowVolume: Bool?
    public var contractAddresses: [String]?
    public var name: String?
    public var marketCap: String?

    public enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case coinrankingUrl = "coinrankingUrl"
        case listedAt = "listedAt"
        case the24HVolume = "24hVolume"
        case symbol = "symbol"
        case tier = "tier"
        case change = "change"
        case color = "color"
        case price = "price"
        case rank = "rank"
        case sparkline = "sparkline"
        case btcPrice = "btcPrice"
        case iconUrl = "iconUrl"
        case lowVolume = "lowVolume"
        case contractAddresses = "contractAddresses"
        case name = "name"
        case marketCap = "marketCap"
    }

    public init(
        uuid: String?,
        coinrankingUrl: String?,
        listedAt: Int?,
        the24HVolume: String?,
        symbol: String?,
        tier: Int?,
        change: String?,
        color: String?,
        price: String?,
        rank: Int?,
        sparkline: [String?]?,
        btcPrice: String?,
        iconUrl: String?,
        lowVolume: Bool?,
        contractAddresses: [String]?,
        name: String?,
        marketCap: String?
    ) {
        self.uuid = uuid
        self.coinrankingUrl = coinrankingUrl
        self.listedAt = listedAt
        self.the24HVolume = the24HVolume
        self.symbol = symbol
        self.tier = tier
        self.change = change
        self.color = color
        self.price = price
        self.rank = rank
        self.sparkline = sparkline
        self.btcPrice = btcPrice
        self.iconUrl = iconUrl
        self.lowVolume = lowVolume
        self.contractAddresses = contractAddresses
        self.name = name
        self.marketCap = marketCap
    }
        
        
       var id: String { uuid ?? "" }
       
       var priceAsDouble: Double {
           return Double(price ?? "") ?? 0.0
       }
       
       var changeAsDouble: Double {
           return Double(change ?? "") ?? 0.0
       }
       
       // Helper for formatted price display
       var formattedPrice: String {
           guard let price = Double(price ?? "") else { return "$0.00" }
           
           let formatter = NumberFormatter()
           formatter.numberStyle = .currency
           formatter.currencySymbol = "$"
           formatter.minimumFractionDigits = 2
           formatter.maximumFractionDigits = price < 1 ? 6 : 2
           
           return formatter.string(from: NSNumber(value: price)) ?? "$\(price)"
       }
       
       // Helper for formatted change display
       var formattedChange: String {
           guard let change = Double(change ?? "") else { return "0.00%" }
           
           let formatter = NumberFormatter()
           formatter.numberStyle = .percent
           formatter.positivePrefix = "+"
           formatter.multiplier = 0.01
           
           return formatter.string(from: NSNumber(value: change)) ?? "\(change)%"
       }
       
       var isPositiveChange: Bool {
           return changeAsDouble >= 0
       }
}

// MARK: - Stats
public struct Stats: Codable, Hashable {
    public var totalMarketCap: String?
    public var total24HVolume: String?
    public var totalExchanges: Int?
    public var totalCoins: Int?
    public var total: Int?
    public var totalMarkets: Int?

    public enum CodingKeys: String, CodingKey {
        case totalMarketCap = "totalMarketCap"
        case total24HVolume = "total24hVolume"
        case totalExchanges = "totalExchanges"
        case totalCoins = "totalCoins"
        case total = "total"
        case totalMarkets = "totalMarkets"
    }

    public init(totalMarketCap: String?, total24HVolume: String?, totalExchanges: Int?, totalCoins: Int?, total: Int?, totalMarkets: Int?) {
        self.totalMarketCap = totalMarketCap
        self.total24HVolume = total24HVolume
        self.totalExchanges = totalExchanges
        self.totalCoins = totalCoins
        self.total = total
        self.totalMarkets = totalMarkets
    }
}


