//
//  PortfolioView.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 22/02/24.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                        .accessibilityLabel("Close Edit Portfolio")
                }
                if selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            guard 
                                let coin = selectedCoin,
                                let amount = Double(quantityText)
                                else {
                                    return
                                }
                            
                            //save to portfolio
                            vm.updatePortfolio(coin: coin, amount: amount)
                            
                            // reset all data
                            removeSelectedCoin()
                            
                            // hide keyboard
                            UIApplication.shared.endEditing()
                        }, label: {
                            Text("Save")
                                .font(.headline)
                                .foregroundColor(Color.theme.accent)
                        })
                    }
                }
            })
            .onChange(of: vm.searchText, initial: false) { oldValue, newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView {
    
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHStack(spacing: 10){
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear,
                                        lineWidth: 1.0)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        })
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        if let portfolioCoins = vm.portfolioCoins.first(where: { $0.id == coin.id }) {
            guard let amount = portfolioCoins.currentHoldings else { return quantityText = "" }
            quantityText = "\(String(describing: amount))"
        } else {
            quantityText = ""
        }
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20){
            HStack {
                Text("Current Price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4",text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(((selectedCoin?.currentPrice ?? 0.0) * (!quantityText.isEmpty ? Double(quantityText)! : 0)).asCurrencyWith2Decimals())
            }
        }
        .padding()
        .font(.headline)
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
        quantityText = ""
    }
}
