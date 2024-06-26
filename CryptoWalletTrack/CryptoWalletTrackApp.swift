//
//  crypto_trackerApp.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 07/02/24.
//

import SwiftUI

@main
struct CryptoWalletTrackApp: App {
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchView: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        
        //for list when you scroll to the top for the refresh area, your custom background color must show there
        UITableView.appearance().backgroundColor = UIColor.clear
        
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
    }
    
    var body: some Scene {
        WindowGroup {
                NavigationStack {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .environmentObject(vm)
        }
    }
}
