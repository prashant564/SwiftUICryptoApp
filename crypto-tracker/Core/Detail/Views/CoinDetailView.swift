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
    
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        print("Initializing DetailView for \(coin.name)")
    }
    
    var body: some View {
        Text(coin.name)
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(coin: dev.coin)
    }
}
