//
//  CoinDetailView.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 27/02/24.
//

import SwiftUI


struct CoinDetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        NavigationStack{
            ZStack {
                if let coin = coin {
                    CoinDetailView(coin: coin)
                }
            }
        }
    }
}


struct CoinDetailView: View {
    
    @StateObject private var vm: CoinDetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(coin: CoinModel) {
        print("Initializing DetailView for \(coin.name)")
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                LineChartView(coin: vm.coin)
               
                Text("Overview")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.theme.accent)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
                Divider()
                
                LazyVGrid(columns: columns,
                          alignment: .leading,
                          spacing: 20,
                          content: {
                    ForEach(vm.overviewStatistics) { stat in
                        MarketStatisticsView(stat: stat)
                    }
                })
                
                Text("Additional Details")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.theme.accent)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
                Divider()
                
                LazyVGrid(columns: columns,
                          alignment: .leading,
                          spacing: 20,
                          content: {
                    ForEach(vm.additionalStatistics) { stat in
                        MarketStatisticsView(stat: stat)
                    }
                })
                
                
            }
            .padding()
            
        }
        .navigationTitle(vm.coin.name)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Text(vm.coin.symbol.uppercased())
                        .font(.subheadline)
                        .foregroundStyle(Color.theme.secondaryText)
                    
                    CoinImageView(coin: vm.coin)
                        .frame(width: 25, height: 25)
                }
            }
        })
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(coin: dev.coin)
    }
}
