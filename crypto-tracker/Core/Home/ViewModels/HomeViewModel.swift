//
//  HomeViewModel.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 09/02/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [MarketStatsModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    
    private var cancellabes = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    
    func addSubscribers() {
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterItems)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellabes)
        
        
        marketDataService.$marketData
            .map {(marketData) -> [MarketStatsModel] in
                var stats: [MarketStatsModel] = []
                guard let data = marketData else {
                    return stats
                }
                let marketCap = MarketStatsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volume24H = MarketStatsModel(title: "24h Volume", value: data.volume)
                let btcDominance = MarketStatsModel(title: "BTC Dominance", value: data.btcDominance)
                let portfolioValue = MarketStatsModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
                stats.append(contentsOf: [
                    marketCap,
                    volume24H,
                    btcDominance,
                    portfolioValue
                ])
                
                return stats
            }
            .sink {[weak self] returnedStatsArray in
                self?.statistics = returnedStatsArray
            }
            .store(in: &cancellabes)
    }
    
    private func filterItems(text: String, startingCoins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return startingCoins
        }
        
        let lowercasedText = text.lowercased()
        
        return startingCoins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowercasedText) || coin.symbol.lowercased().contains(lowercasedText) || coin.id.contains(lowercasedText)
        }
    }
    
}
