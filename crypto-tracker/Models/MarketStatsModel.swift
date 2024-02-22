//
//  MarketStatsModel.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 20/02/24.
//

import Foundation

struct MarketStatsModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}

