//
//  MainViewSpy.swift
//  Currency ConverterTests
//
//  Created by Sylvan Ash on 06/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation
@testable import Currency_Converter

class MainViewSpy: MainViewProtocol {
    private(set) var didCallShowLoadingView = false
    private(set) var didCallHideLoadingView = false
    private(set) var didCallReloadData = false
    private(set) var didCallShowPickerView = false
    private(set) var didCallHidePickerView = false
    private(set) var didCallUpdateSelectedCurrency = false
    private(set) var didCallShowError = false
    private(set) var currencies: [Currency]?
    private(set) var name: String?
    private(set) var message: String?

    func showLoadingView() {
        didCallShowLoadingView = true
    }

    func hideLoadingView() {
        didCallHideLoadingView = true
    }

    func reloadData() {
        didCallReloadData = true
    }

    func showPickerView(with currencies: [Currency]) {
        didCallShowPickerView = true
        self.currencies = currencies
    }

    func hidePickerView() {
        didCallHidePickerView = true
    }

    func updateSelectedCurrency(name: String) {
        didCallUpdateSelectedCurrency = true
        self.name = name
    }

    func showError(message: String) {
        didCallShowError = true
        self.message = message
    }
}
