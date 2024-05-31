//
//  UIApplication.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 15/02/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    //disable keyboard based on an app event
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
