//
//  CoinDetailViewModel.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 25/05/24.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    
//    @Published var coinDetails: CoinDetailModel? = nil
    @Published var overviewStatistics: [MarketStatsModel] = []
    @Published var additionalStatistics: [MarketStatsModel] = []
    
    @Published var coin: CoinModel
    private let coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        coinDetailDataService = CoinDetailDataService(coin: coin)
        
        addSubscribers()
    }
    
    func addSubscribers() {
        coinDetailDataService.$coinDetails
            .combineLatest($coin)
            .map(setupOverviewAndAddtionalStatsArray)
            .sink { [weak self] (returnedArrays) in
                guard let self = self else {
                    return
                }
                self.overviewStatistics = returnedArrays.overview
                self.additionalStatistics = returnedArrays.additional
//                self.coinDetails = returnedCoinDetails
            }
            .store(in: &cancellables)
    }
    
    private func setupOverviewAndAddtionalStatsArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [MarketStatsModel], additional: [MarketStatsModel]) {
        // overview
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange =  coinModel.priceChangePercentage24H
        let priceStat = MarketStatsModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
    
        let marketCap = "$" + (Double(coinModel.marketCap ?? 0).formattedWithAbbreviations())
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = MarketStatsModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = MarketStatsModel(title: "Rank", value: rank)

        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = MarketStatsModel(title: "Volume", value: volume)
        
        let overviewArray: [MarketStatsModel] = [
            priceStat,
            marketCapStat,
            rankStat,
            volumeStat
        ]
        
        //additional
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = MarketStatsModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = MarketStatsModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = MarketStatsModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = MarketStatsModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange2)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = MarketStatsModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = MarketStatsModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [MarketStatsModel] = [
            highStat,
            lowStat,
            priceChangeStat,
            marketCapChangeStat,
            blockStat,
            hashingStat
        ]
        
        
        return (overviewArray, additionalArray)
    }
}
