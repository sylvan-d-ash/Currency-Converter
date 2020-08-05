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
    private var currencies = [String: Currency]()

    init(view: MainViewProtocol, webservice: Webservice) {
        self.view = view
        self.webservice = webservice
    }

    func viewDidLoad() {
        view.toggleLoading(isLoading: true)

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
                    self?.view.toggleLoading(isLoading: false)
                    // TODO:
                    // - show error + prompt to retry/cancel
                case .success(let json):
                    print(json)
                    guard let jsonDict = json as? [String: Any], let currenciesDict = jsonDict[Keys.currencies] as? [String: String] else {
                        self?.view.toggleLoading(isLoading: false)
                        return
                    }

                    var currencies = [String: Currency]()
                    for (code, name) in currenciesDict {
                        let currency = Currency(code: code, name: name)
                        currencies[code] = currency
                    }
                    self?.currencies = currencies

                    self?.fetchExchangeRates()
            }
        }
    }
}

private extension MainPresenter {
    func fetchExchangeRates() {
        webservice.makeRequest(endpoint: .live(source: nil)) { [weak self] result in
            self?.view.toggleLoading(isLoading: false)

            switch result {
            case .failure(let error):
                print(error)
                // TODO:
                // - show error + prompt to retry/cancel
            case .success(let json):
                print(json)
                guard let jsonDict = json as? [String: Any], let ratesDict = jsonDict[Keys.rates] as? [String: String] else {
                    return
                }

                for (pair, rate) in ratesDict {
                    var code = pair
                    code.removeSubrange(code.startIndex..<code.index(code.startIndex, offsetBy: Keys.usd.count))
                    self?.currencies[code]?.price = rate
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
