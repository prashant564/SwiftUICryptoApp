//
//  MarketDataService.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 22/02/24.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketData? = nil
    
    var marketDataSubscription: AnyCancellable?
    
    init() {
        fetchGlobalMarketData()
    }
    
    
    func fetchGlobalMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
            return
        }
        
        marketDataSubscription = NetworkManager.getFetch(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedValue in
                self?.marketData = returnedValue.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
