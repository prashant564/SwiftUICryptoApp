//
//  SwiftUIView.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 27/05/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let defaultUrl = URL(string: "https://www.google.com")!
    let youtubeUrl = URL(string: "https://www.youtube.com")!
    let coffeeUrl = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let personalURL = URL(string: "https://github.com/prashant564")!
    
    var body: some View {
        NavigationView {
            List {
                Section("Swiftful Thinking") {
                    VStack(alignment: .leading) {
                        Image("logo")
                            .resizable()
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Text ("This app was made by following a @SwiftfulThinking course on YouTube. It uses MVVM Architecture, Combine, and CoreData!")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor (Color.theme.accent)
                    }
                    .padding(.vertical)
                    Link("Subscribe on Youtube", destination: youtubeUrl)
                    Link("Support for his coffee addiction", destination: coffeeUrl)
                }
                
                Section("Coin Gecko") {
                    VStack(alignment: .leading) {
                        Image("coingecko")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor (Color.theme.accent)
                    }
                    .padding(.vertical)
                    Link("Visit Coin Gecko", destination: coingeckoURL)
                }
                
                Section("Developer") {
                    VStack(alignment: .leading) {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("This app was developed by Prashant Dixit. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, and data persistance.")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor (Color.theme.accent)
                    }
                    .padding(.vertical)
                    Link("Github Url", destination: personalURL)
                }
                
                Section("Application") {
                    Link("Terms of Service", destination: defaultUrl)
                    Link("Privacy Policy", destination: defaultUrl)
                    Link ("Company Website", destination: defaultUrl)
                    Link("Learn More", destination: defaultUrl)
                }
            }
            .font(.headline)
            .accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                    .accessibilityLabel("Close Settings")
                }
            })
        }
    }
}

#Preview {
    SettingsView()
}
