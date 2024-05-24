//
//  CoinDetailViewModel.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 25/05/24.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    
    @Published var coinDetails: CoinDetailModel? = nil
    private let coin: CoinModel
    
    private let coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        coinDetailDataService = CoinDetailDataService(coin: coin)
        
        addSubscribers()
    }
    
    func addSubscribers() {
        
        coinDetailDataService.$coinDetails
            .sink { [weak self] (returnedCoinDetails) in
                guard let self = self else {
                    return
                }
                self.coinDetails = returnedCoinDetails
            }
            .store(in: &cancellables)
    }
}
