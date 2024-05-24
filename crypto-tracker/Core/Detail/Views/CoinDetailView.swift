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
    
    @StateObject var vm: CoinDetailViewModel
    
    init(coin: CoinModel) {
        print("Initializing DetailView for \(coin.name)")
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }
    
    var body: some View {
        Text("Hello")
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(coin: dev.coin)
    }
}
