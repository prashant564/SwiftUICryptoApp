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
    let privacyPolicyUrl = URL(string: "https://doc-hosting.flycricket.io/cryptowallettrack-privacy-policy/c2cc72e4-2c3b-41bb-a8e4-4521ff4a7f08/privacy")!
    let termsAndConditionUrl = URL(string: "https://doc-hosting.flycricket.io/cryptowallettrack/712b8d5d-f39f-45ba-8702-bccea196b600/terms")!
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.theme.background
                    .ignoresSafeArea()
                
                List {
                    Section("Developer") {
                        VStack(alignment: .leading) {
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            Text("This app was developed by Prashant Dixit. It uses SwiftUI and is written 100% in Swift. This app gives users latest crypto market updates and let's them keep a track of their investments.")
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor (Color.theme.accent)
                        }
                        .padding(.vertical)
                        Link("Github Url", destination: personalURL)
                    }
                    .listRowBackground(Color.theme.background.opacity(0.5))
                    
                    Section("Application") {
                        Link("Terms of Service", destination: termsAndConditionUrl)
                        Link("Privacy Policy", destination: privacyPolicyUrl)
                    }
                    .listRowBackground(Color.theme.background.opacity(0.5))
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
}

#Preview {
    SettingsView()
}
