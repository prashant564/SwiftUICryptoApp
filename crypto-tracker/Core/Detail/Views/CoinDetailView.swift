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
    @State private var showFullDescription: Bool = false
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
                
                //description
                ZStack {
                    if let coinDescription = vm.coinDetails?.readableDescription, vm.coinDetails?.readableDescription != nil {
                        VStack(alignment: .leading) {
                            Text(coinDescription)
                                .lineLimit(showFullDescription ? nil : 3)
                                .font(.callout)
                                .foregroundStyle(Color.theme.secondaryText)
                            
                            
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    showFullDescription.toggle()
                                }
                            }, label: {
                                Text(showFullDescription ? "See Less" : "Read More")
                                    .foregroundStyle(Color.teal)
                                    .font(.footnote)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .padding(.vertical, 4)
                            })
                            
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    }
                }
                
                
                // overview statistics
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
                
                VStack(alignment: .leading, spacing: 20) {
                    if let websiteString = vm.coinDetails?.links?.homepage, vm.coinDetails?.links?.homepage != nil {
                        let url = URL(string: websiteString.first ?? "")
                        Link("Website", destination: url!)
                    }
                    
                    if let redditString = vm.coinDetails?.links?.subredditURL, vm.coinDetails?.links?.subredditURL != nil {
                        let url = URL(string: redditString)
                        Link("Reddit", destination: url!)
                    }
                }
                .foregroundStyle(.blue)
                .font(.headline)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            }
            .padding()
            
        }
        .navigationTitle(vm.coin.name)
        .background(
            Color.theme.background
                .ignoresSafeArea()
        )
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
