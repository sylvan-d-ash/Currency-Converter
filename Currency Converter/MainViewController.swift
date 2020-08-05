//
//  MainViewController.swift
//  Currency Converter
//
//  Created by Sylvan Ash on 04/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private let currencyButton = UIButton(type: .system)
    private let currencyTextfield = UITextField()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private weak var loadingView: LoadingView?

    private var pickerView: CurrencyPickerView?
    private var shouldShowPickerview = false

    private var currencies: [Currency] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

private extension MainViewController {
    enum Dimensions {
        static let spacing: CGFloat = 10
    }

    func setupSubviews() {
        view.backgroundColor = .white

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.spacing),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.spacing),
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Dimensions.spacing),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 40
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: "\(CurrencyCell.self)")
        container.addSubview(tableView)

        let headerView = UIView()
        container.addSubview(headerView)

        currencyTextfield.delegate = self
        currencyTextfield.keyboardType = .decimalPad
        currencyTextfield.borderStyle = .roundedRect
        headerView.addSubview(currencyTextfield)

        currencyButton.addTarget(self, action: #selector(chooseCurrencyTapped), for: .touchUpInside)
        currencyButton.setTitle("USD", for: .normal)
        headerView.addSubview(currencyButton)

        [currencyTextfield, currencyButton, tableView, headerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            currencyTextfield.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            currencyTextfield.topAnchor.constraint(equalTo: headerView.topAnchor),
            currencyTextfield.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),

            currencyButton.leadingAnchor.constraint(equalTo: currencyTextfield.trailingAnchor, constant: Dimensions.spacing),
            currencyButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            currencyButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            currencyButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            currencyButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 1/6),

            headerView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: container.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 40),

            tableView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Dimensions.spacing),
            tableView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
    }

    func toggleLoading(isLoading: Bool) {
        if isLoading {
            loadingView = LoadingView(self.view).show()
        } else {
            loadingView?.terminate()
            loadingView = nil
        }
    }

    @objc func chooseCurrencyTapped() {
        guard currencies.count > 0 else { return }
        shouldShowPickerview = !shouldShowPickerview

        if shouldShowPickerview {
            showPickerView()
        } else {
            pickerView?.hide()
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(false)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CurrencyCell.self)", for: indexPath) as? CurrencyCell else {
            return UITableViewCell()
        }

        let currency = currencies[indexPath.row]
        cell.update(with: (currency.name, "\(indexPath).00"))
        return cell
    }
}

extension MainViewController: CurrencyPickerViewDelegate {
    private func showPickerView() {
        if pickerView == nil {
            let pickerView = CurrencyPickerView()
            pickerView.delegate = self
            pickerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(pickerView)

            NSLayoutConstraint.activate([
                pickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                pickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                pickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            ])

            self.pickerView = pickerView
        }

        pickerView?.show(currencies: currencies)
    }

    func didSelect(currency: Currency) {
        print(currency)
        shouldShowPickerview = false
    }
}
