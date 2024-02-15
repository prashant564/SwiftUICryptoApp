//
//  crypto_trackerApp.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 07/02/24.
//

import SwiftUI

@main
struct crypto_trackerApp: App {
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
