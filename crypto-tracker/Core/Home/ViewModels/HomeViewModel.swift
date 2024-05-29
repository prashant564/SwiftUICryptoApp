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
    @Published var sortOption: SortOption = .rankReversed
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellabes = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    
    func addSubscribers() {
        // updates all coins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellabes)
        
        //updates portfolio coins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels, portfolioEntities) -> [CoinModel] in
                //loop over all coins list and for every coin search if it exists in portfolioEntities list,
                // compactMap because it can return null when no match
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                            return nil
                        }
                    
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] returnedCoins in
                //checking if we really have the self for the portfolioCoins
                guard let self = self else {
                    return
                }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellabes)
        
        // update market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map {(marketData, portfolioCoins) -> [MarketStatsModel] in
                var stats: [MarketStatsModel] = []
                guard let data = marketData else {
                    return stats
                }
                let marketCap = MarketStatsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volume24H = MarketStatsModel(title: "24h Volume", value: data.volume)
                let btcDominance = MarketStatsModel(title: "BTC Dominance", value: data.btcDominance)
                let portfolioValue = portfolioCoins
                                        .map({ $0.currentHoldingsValue })
                                        .reduce(0, +)
                let previousValue = portfolioCoins
                                        .map { coin -> Double in
                                            let currentValue = coin.currentHoldingsValue
                                            let percentageChange = (coin.priceChangePercentage24H ?? 0)/100
                                            let previousValue = currentValue/(1 + percentageChange)
                                            return previousValue
                                        }
                                        .reduce(0, +)
                let percentChange = ((portfolioValue - previousValue)/previousValue)*100
                        
                
                let portfolio = MarketStatsModel(
                                    title: "Portfolio Value",
                                    value: portfolioValue.asCurrencyWith2Decimals(),
                                    percentageChange: percentChange)
                stats.append(contentsOf: [
                    marketCap,
                    volume24H,
                    btcDominance,
                    portfolio
                ])
                
                return stats
            }
            .sink {[weak self] returnedStatsArray in
                self?.statistics = returnedStatsArray
            }
            .store(in: &cancellabes)
    
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        coinDataService.getCoins()
        marketDataService.fetchGlobalMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterItems(text: text, startingCoins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        
        return updatedCoins
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
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        case .rank, .holdings:
            coins.sort(by: { $0.rank > $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank < $1.rank })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
}
