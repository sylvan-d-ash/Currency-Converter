//
//  MainPresenter.swift
//  Currency Converter
//
//  Created by Sylvan Ash on 05/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

class MainPresenter {
    private weak var view: MainViewProtocol!
    private let interactor: MainInteractorProtocol
    private var currencies = [Currency]()
    private var selectedCurrency: Currency?
    private var shouldShowPickerView = false
    private var value: Double = 0
    var numberOfItems: Int {
        guard value > 0 else { return 0 }
        return currencies.count
    }

    init(view: MainViewProtocol, interactor: MainInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }

    func viewDidLoad() {
        toggleLoadingIndicator(isShown: true)

        interactor.fetchCurrencies { [weak self] result in
            guard let self = self else { return }
            self.toggleLoadingIndicator(isShown: false)

            switch result {
                case .failure(let error):
                    self.view.showError(message: error.localizedDescription)

                case .success(let currencies):
                    self.currencies = currencies

                    for currency in currencies where currency.code == "USD" {
                        self.selectedCurrency = currency
                    }
            }
        }
    }

    func didTapShowPickerView() {
        guard currencies.count > 0 else { return }

        shouldShowPickerView = !shouldShowPickerView
        if shouldShowPickerView {
            view.showPickerView(with: currencies)
        } else {
            view.hidePickerView()
        }
    }

    func didSelect(currency: Currency) {
        selectedCurrency = currency
        didTapShowPickerView()
        view.reloadData()
        view.updateSelectedCurrency(name: currency.code)
    }

    func valueDidChange(_ value: String?) {
        guard let value = value, let decimalValue = Double(value) else { return }
        self.value = decimalValue
        view.reloadData()
    }

    func configure(_ cell: CurrencyCell, forRowAt index: Int) {
        let currency = currencies[index]
        let price = convert(value: value, atRate: currency.rate)
        let roundedPrice = round(price * 100) / 100
        cell.update(with: (currency.name, "\(roundedPrice)"))
    }
}

private extension MainPresenter {
    func convert(value: Double, atRate rate: Double) -> Double {
        guard let baseCurrency = selectedCurrency else { return 0 }
        let valueToUsd = value / baseCurrency.rate
        let convertedValue = valueToUsd * rate
        return convertedValue
    }

    func toggleLoadingIndicator(isShown: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isShown {
                self?.view.showLoadingView()
            } else {
                self?.view.hideLoadingView()
            }
        }
    }
}

private enum Keys {
    static let currencies = "currencies"
    static let rates = "quotes"
    static let usd = "USD"
    static let defaultSource = "USDUSD"
}
