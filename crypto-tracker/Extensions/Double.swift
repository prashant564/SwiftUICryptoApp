//
//  Double.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 08/02/24.
//

import Foundation

extension Double {
    
    /// converts a double into currency to 2 decimal places
    /// ```
    ///Convert 1234.56 to $1,234.56
    /// ```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    /// converts a double into currency to 2 decimal places
    /// ```
    ///Convert 1234.56 to "$1,234.56"
    /// ```
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    
    /// converts a double into currency to 2-6 decimal places
    /// ```
    ///Convert 1234.56 to $1,234.56
    ///Convert 123.456 to $123.456
    ///Convert 0.123456 to $0.123456
    /// ```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
//        formatter.currencyCode = "usd"
//        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        
        return formatter
    }
    
    /// converts a double into currency to 2-6 decimal places
    /// ```
    ///Convert 1234.56 to "$1,234.56"
    ///Convert 123.456 to "$123.456"
    ///Convert 0.123456 to "$0.123456"
    /// ```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    /// converts a double into string representation
    /// ```
    ///Convert 12.3456 to "12.34"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    /// converts a double into string representation with percent symbol
    /// ```
    ///Convert 12.3456 to "12.34"
    /// ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
}
