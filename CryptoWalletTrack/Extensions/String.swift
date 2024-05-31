//
//  String.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 27/05/24.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
