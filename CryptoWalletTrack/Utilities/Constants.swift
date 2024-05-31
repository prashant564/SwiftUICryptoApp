//
//  Constants.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 01/06/24.
//

import Foundation

private let dummyCoin = CoinModel(
    id: "",
    symbol: "",
    name: "",
    image: "",
    currentPrice: 0,
    marketCap: 0,
    marketCapRank: 1,
    fullyDilutedValuation: 0,
    totalVolume: 0,
    high24H: 0,
    low24H: 0,
    priceChange24H: 0,
    priceChangePercentage24H: 6.87944,
    marketCapChange24H: 72110681879,
    marketCapChangePercentage24H: 6.74171,
    circulatingSupply: 18653043,
    totalSupply: 21000000,
    maxSupply: 21000000,
    ath: 61712,
    athChangePercentage: -0.97589,
    athDate: "2021-03-13T20:49:26.606Z",
    atl: 67.81,
    atlChangePercentage: 90020.24075,
    atlDate: "2013-07-06T00:00:00.000Z",
    lastUpdated: "2021-03-13T23:18:10.268Z",
    sparklineIn7D: SparklineIn7D(price: []),
    priceChangePercentage24HInCurrency: 3952.64,
    currentHoldings: 1.5)

var placeholderCoins: [CoinModel] {
    Array(repeating: dummyCoin, count: 10)
                .enumerated()
                .map { index, coin in
                    var newCoin = coin
                    newCoin.id = UUID().uuidString
                    return newCoin
                }
}

var placeholderStats: [MarketStatsModel] {
    [MarketStatsModel(title: "Market Cap", value: "$2.35TR", percentageChange: 25.34),
             MarketStatsModel(title: "Total Volume", value: "$1.25TR", percentageChange: nil),
              MarketStatsModel(title: "Market Cap", value: "$2.35TR", percentageChange: -25.34)]
}
