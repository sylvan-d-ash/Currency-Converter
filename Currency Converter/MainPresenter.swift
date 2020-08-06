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
    var value: Decimal = 0
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
                    print(json)
                    guard let jsonDict = json as? [String: Any], let currenciesDict = jsonDict[Keys.currencies] as? [String: String] else {
                        self?.toggleLoadingIndicator(isShown: false)
                        return
                    }

                    var currencies = [Currency]()
                    for (code, name) in currenciesDict {
                        let currency = Currency(code: code, name: name)
                        currencies.append(currency)
                    }
                    self?.currencies = currencies

                    self?.fetchExchangeRates()
            }
        }
    }

    func didSelect(currency: Currency) {
        selectedCurrency = currency
    }

    func configure(_ cell: CurrencyCell, forRowAt index: Int) {
        //
    }
}

private extension MainPresenter {
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
                print(json)
                guard let jsonDict = json as? [String: Any], let rates = jsonDict[Keys.rates] as? [String: String] else {
                    return
                }

//                for (pair, rate) in ratesDict {
//                    var code = pair
//                    code.removeSubrange(code.startIndex..<code.index(code.startIndex, offsetBy: Keys.usd.count))
//                    self?.currencies[code]?.rate = rate
//                }

                for i in 0..<self.currencies.count {
                    var currency = self.currencies[i]
                    let key = "\(Keys.usd)\(currency.code)"
                    guard let rate = rates[key] else { continue }
                    currency.rate = rate
                    self.currencies[i] = currency
                }
            }
        }
    }
}

private enum Keys {
    static let currencies = "currencies"
    static let rates = "quotes"
    static let usd = "USD"
}
