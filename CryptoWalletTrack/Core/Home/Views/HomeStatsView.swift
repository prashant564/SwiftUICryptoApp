//
//  HomeStatsView.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 20/02/24.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(vm.statistics.isEmpty ? placeholderStats : vm.statistics) { stat in
                MarketStatisticsView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
        .redacted(reason: vm.statistics.isEmpty ? .placeholder : [])
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortfolio: .constant(true))
            .environmentObject(dev.homeVM)
    }
}
