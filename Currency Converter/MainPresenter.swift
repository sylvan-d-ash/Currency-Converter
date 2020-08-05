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
                    // TODO:
                    // - show error + prompt to retry/cancel
                case .success(let json):
                    print(json)
                    if let jsonDict = json as? [String: Any], let currenciesDict = jsonDict[Keys.currencies] as? [String: String] {
                        var currencies = [String: Currency]()
                        for (code, name) in currenciesDict {
                            let currency = Currency(code: code, name: name)
                            currencies[code] = currency
                        }
                        self?.currencies = currencies
                    }

                    // TODO:
                    // - parse JSON into dict of currencies
                    // - fetch exchange rates
                    self?.fetchExchangeRates()
            }
        }
    }
}

private extension MainPresenter {
    func fetchExchangeRates() {
        webservice.makeRequest(endpoint: .live(source: nil)) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let json):
                print(json)
            }
        }
    }
}

private enum Keys {
    static let currencies = "currencies"
    static let rates = "quotes"
}
