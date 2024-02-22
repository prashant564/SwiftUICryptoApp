//
//  MarketStatisticsView.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 20/02/24.
//

import SwiftUI

struct MarketStatisticsView: View {
    
    let stat: MarketStatsModel
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    
                    .rotationEffect(Angle(degrees: stat.percentageChange ?? 0 >= 0 ? 0 : 180))
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor(stat.percentageChange ?? 0 >= 0 ? Color.theme.green :  Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0) 
        }
    }
}

struct MarketStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        MarketStatisticsView(stat: dev.stat3)
    }
}
