//
//  DepositViewModel.swift
//  depositCalculatorApp
//
//  Created by ntvlbl on 30.11.2024.
//

import Foundation


class DepositViewModel<T> {
    private var dataModel: T?

    var data: [(String, String)] = []

    var onReloadData: (() -> Void)?

    func updateDataModel(_ model: T) {
        self.dataModel = model
        processData()
    }

    private func processData() {
        guard let deposit = dataModel as? Deposit else { return }

        let totalReturn = deposit.calculateTotalReturn()
        let ownFunds = deposit.amount
        let bankInterest = totalReturn - ownFunds

        data = [
            ("Deposit Amount", String(format: "%.2f", ownFunds)),
            ("Interest Rate (%)", String(format: "%.2f", deposit.interestRate)),
            ("Term (Months)", "\(deposit.termInMonths)"),
            ("Own Funds", String(format: "%.2f", ownFunds)),
            ("Bank Interest", String(format: "%.2f", bankInterest)),
            ("Total Return", String(format: "%.2f", totalReturn))
        ]

        onReloadData?()
    }
}
