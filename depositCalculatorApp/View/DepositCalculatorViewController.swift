//
//  DepositCalculatorViewController.swift
//  depositCalculatorApp
//
//  Created by ntvlbl on 30.11.2024.
//

import UIKit
import SnapKit

class DepositCalculatorViewController: UIViewController {
    private let viewModel = DepositViewModel<Deposit>()


    private let currencySegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["KZT", "USD", "EUR"])
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .systemTeal
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.systemTeal], for: .normal)
        return control
    }()

    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter deposit amount"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()

    private let interestRateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter interest rate (%)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()

    private let termSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["6 months", "12 months"])
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .systemTeal
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.systemTeal], for: .normal)
        return control
    }()

    private let summaryContainer = UIView()
    private let summaryLabel = UILabel()
    private let showDetailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Details", for: .normal)
        button.backgroundColor = .systemTeal
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }()

    private let calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Calculate", for: .normal)
        button.backgroundColor = .systemTeal
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupBindings()
        setupActions()
        summaryContainer.isHidden = true
    }

    private func setupNavigationBar() {
        title = "Deposit Calculator App"
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setupUI() {
        view.backgroundColor = .white

        summaryContainer.layer.cornerRadius = 12
        summaryContainer.layer.borderWidth = 1
        summaryContainer.layer.borderColor = UIColor.systemTeal.cgColor
        summaryContainer.backgroundColor = UIColor(white: 0.98, alpha: 1)
        summaryLabel.font = UIFont.boldSystemFont(ofSize: 20)
        summaryLabel.textAlignment = .center
        summaryLabel.textColor = .systemTeal
        summaryLabel.numberOfLines = 2

        summaryContainer.addSubview(summaryLabel)
        summaryContainer.addSubview(showDetailsButton)
        view.addSubview(currencySegmentedControl)
        view.addSubview(amountTextField)
        view.addSubview(interestRateTextField)
        view.addSubview(termSegmentedControl)
        view.addSubview(summaryContainer)
        view.addSubview(calculateButton)

        currencySegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(currencySegmentedControl.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        interestRateTextField.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        termSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(interestRateTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        summaryContainer.snp.makeConstraints { make in
            make.top.equalTo(termSegmentedControl.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }

        summaryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        showDetailsButton.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(40)
        }

        calculateButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }

    private func setupBindings() {
        viewModel.onReloadData = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let firstResult = self.viewModel.data.last {
                    let months = self.termSegmentedControl.titleForSegment(at: self.termSegmentedControl.selectedSegmentIndex) ?? ""
                    self.summaryLabel.text = "For \(months)\nTotal Return: \(firstResult.1)"
                    self.summaryContainer.isHidden = false
                }
            }
        }
    }

    private func setupActions() {
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
        showDetailsButton.addTarget(self, action: #selector(showDetailsTapped), for: .touchUpInside)
        termSegmentedControl.addTarget(self, action: #selector(termChanged), for: .valueChanged)
    }

    @objc private func calculateButtonTapped() {
        performCalculation()
    }

    @objc private func termChanged() {
        performCalculation()
    }

    private func performCalculation() {
        guard
            let amountText = amountTextField.text,
            let depositAmount = Double(amountText),
            let interestRateText = interestRateTextField.text,
            let interestRate = Double(interestRateText) else {
            showErrorAlert(message: "Please enter valid numbers.")
            return
        }

        let termInMonths = termSegmentedControl.selectedSegmentIndex == 0 ? 6 : 12

        let deposit = Deposit(amount: depositAmount, interestRate: interestRate, termInMonths: termInMonths)
        viewModel.updateDataModel(deposit)
    }

    @objc private func showDetailsTapped() {
        let detailsVC = DepositDetailsViewController(data: viewModel.data)
        if let sheet = detailsVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(detailsVC, animated: true)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
