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
    @Published var sortOption: SortOption = .holdings
    
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
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                            return nil
                        }
                    
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] returnedCoins in
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
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        let filteredCoins = filterItems(text: text, startingCoins: coins)
        var sortedCoinsList: [CoinModel] {
            switch sort {
            case .price:
                return filteredCoins.sorted { coin1, coin2 in
                    return coin1.currentPrice > coin2.currentPrice
                }
            case .priceReversed:
                return filteredCoins.sorted { coin1, coin2 in
                    return coin1.currentPrice < coin2.currentPrice
                }
            case .rank, .holdings:
                return filteredCoins.sorted { coin1, coin2 in
                    return coin1.rank > coin2.rank
                }
            case .rankReversed, .holdingsReversed:
                return filteredCoins.sorted { coin1, coin2 in
                    return coin1.rank < coin2.rank
                }
            }
        }
        
        return sortedCoinsList
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
