//
//  CircleButtonAnimationView.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 08/02/24.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0: 1.0)
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none, value: UUID())
            .onAppear {
                animate.toggle()
            }
            
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(true))
        .frame(width: 100, height: 100)
        .foregroundColor(.red)
}
