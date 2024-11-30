//
//  DepositDetailsViewController.swift
//  depositCalculatorApp
//
//  Created by ntvlbl on 30.11.2024.
//

import Foundation
import UIKit

class DepositDetailsViewController: UIViewController {
    private let data: [(String, String)]
    private let tableView = UITableView()

    init(data: [(String, String)]) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Deposit Details"

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.register(DepositCalculatorCell.self, forCellReuseIdentifier: DepositCalculatorCell.identifier)
        tableView.dataSource = self
    }
}

extension DepositDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DepositCalculatorCell.identifier, for: indexPath) as! DepositCalculatorCell
        let data = self.data[indexPath.row]
        cell.configure(with: data.0, value: data.1)
        return cell
    }
}
