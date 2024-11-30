//
//  Deposit.swift
//  depositCalculatorApp
//
//  Created by ntvlbl on 30.11.2024.
//

import Foundation
struct Deposit {
    var amount: Double
    var interestRate: Double
    var termInMonths: Int
    
    func calculateTotalReturn() -> Double {
        return amount * pow(1 + (interestRate / 100), Double(termInMonths) / 12)
    }
}
