//
//  HomeView.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 07/02/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = true // animate right
    @State private var showPortfolioView: Bool = false // new sheet
    @State private var showSettingsView: Bool = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showCoinDetailView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.theme.background
                    .ignoresSafeArea()
                    .sheet(isPresented: $showPortfolioView, content: {
                        PortfolioView()
                            .environmentObject(vm)
                    })
                
                //content layer
                VStack {
                    homeHeader
                    
                    HomeStatsView(showPortfolio: $showPortfolio)
                    
                    SearchBarView(searchText: $vm.searchText)
                    
                    columnTitles
                    
                    if !showPortfolio {
                        allCoinsList
                            .transition(.move(edge: .leading))
                    }
                    
                    if(showPortfolio){
                        VStack(alignment: .center) {
                            if(vm.portfolioCoins.isEmpty && vm.searchText.isEmpty) {
                                Image("empty-list")
                                    .padding(.vertical)
                                Text("You haven't added any coins to your portfolio yet! Click the + button to get started. 🤔")
                                    .font(.callout)
                                    .foregroundStyle(Color.theme.accent)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            } else {
                                portfolioCoinsList
                            }
                        }
                        .transition(.move(edge: .trailing))
                    }
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                }
                .sheet(isPresented: $showSettingsView, content: {
                    SettingsView()
                        .environmentObject(vm)
                })
                .navigationDestination(isPresented: $showCoinDetailView) {
                    CoinDetailLoadingView(coin: $selectedCoin)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeView()
                .navigationBarHidden(false)
        }
        .environmentObject(dev.homeVM)
        
        
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "gearshape")
                .animation(.none, value: UUID())
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none, value: UUID())
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortfolio.toggle()
                        HapticManager.notification(type: .success)
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach((vm.allCoins.isEmpty ? placeholderCoins : vm.allCoins)) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .redacted(reason: vm.allCoins.isEmpty ? .placeholder : [])
                    .onTapGesture {
                        onCoinRowItemClicked(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
            
        }
        .listStyle(PlainListStyle())
        .refreshable {
            vm.reloadData()
        }
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .onTapGesture {
                        onCoinRowItemClicked(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
            
        }
        .listStyle(PlainListStyle())
    }
    
    private func onCoinRowItemClicked(coin: CoinModel) {
        selectedCoin = coin
        showCoinDetailView.toggle()
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text ("Coin")
                Image (systemName: "chevron.down")
                    .opacity ((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0: 180))
            }
            .onTapGesture {
                withAnimation(.snappy) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
               
            }
            Spacer()
            if showPortfolio {
                HStack(spacing:4){
                    Text ("Holdings")
                    Image (systemName: "chevron.down")
                        .opacity ((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0: 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.snappy) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text ("Price")
                Image (systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.snappy) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
        
    }
}
