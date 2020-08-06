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
    private let webservice: Webservice
    private(set) var currencies = [Currency]()
    var value: Double = 0
    var numberOfItems: Int {
        guard value > 0 else { return 0 }
        return currencies.count
    }
    private var selectedCurrency: Currency?

    init(view: MainViewProtocol, webservice: Webservice) {
        self.view = view
        self.webservice = webservice
    }

    func viewDidLoad() {
        toggleLoadingIndicator(isShown: true)

        // TODO:
        // - add interactor
        // - interactor will have web and cache service
        // - interactor to first check cache for data
        // - if no data in cache, or if cache data has expired
        // - fetch data from web
        // - after fetch, update cache
        // - complete

        webservice.makeRequest(endpoint: .currencies) { [weak self] result in
            switch result {
                case .failure(let error):
                    print(error)
                    self?.toggleLoadingIndicator(isShown: false)

                case .success(let json):
                    guard (self?.parseCurrencies(json: json) ?? false) else { return }

                    self?.fetchExchangeRates()
            }
        }
    }

    func didSelect(currency: Currency) {
        selectedCurrency = currency
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
        let valueToUsd = value * baseCurrency.rate
        let convertedValue = valueToUsd * rate
        return convertedValue
    }

    func toggleLoadingIndicator(isShown: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.view.toggleLoading(isLoading: isShown)
        }
    }

    func fetchExchangeRates() {
        webservice.makeRequest(endpoint: .live(source: nil)) { [weak self] result in
            guard let self = self else { return }
            self.toggleLoadingIndicator(isShown: false)

            switch result {
            case .failure(let error):
                print(error)

            case .success(let json):
                self.parseExchangeRates(json: json)
            }
        }
    }

    func parseCurrencies(json: Any) -> Bool {
        guard let jsonDict = json as? [String: Any], let currenciesDict = jsonDict[Keys.currencies] as? [String: String] else {
            self.toggleLoadingIndicator(isShown: false)
            return false
        }

        var currencies = [Currency]()
        for (code, name) in currenciesDict {
            let currency = Currency(code: code, name: name)
            currencies.append(currency)
        }
        self.currencies = currencies

        return true
    }

    func parseExchangeRates(json: Any) {
        guard let jsonDict = json as? [String: Any], let rates = jsonDict[Keys.rates] as? [String: Double] else {
            return
        }

        for i in 0..<currencies.count {
            var currency = currencies[i]
            let key = "\(Keys.usd)\(currency.code)"
            guard let rate = rates[key] else { continue }

            currency.rate = rate
            currencies[i] = currency

            if key == Keys.defaultSource {
                selectedCurrency = currency
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
