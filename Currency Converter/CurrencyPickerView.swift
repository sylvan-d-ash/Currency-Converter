//
//  CurrencyPickerView.swift
//  Currency Converter
//
//  Created by Sylvan Ash on 05/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class CurrencyPickerView: UIView {
    private let pickerView = UIPickerView(frame: .zero)
    private var currencies: [String] = []

    init() {
        super.init(frame: .zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(currencies: [String]) {
        isHidden = false
        self.currencies = currencies
        pickerView.reloadAllComponents()
    }

    func hide() {
        isHidden = true
    }
}

private extension CurrencyPickerView {
    func setupSubviews() {
        backgroundColor = .clear

        let dimView = UIView()
        dimView.backgroundColor = .black
        dimView.alpha = 0.5
        addSubview(dimView)
        dimView.fillParent()

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pickerView)
        pickerView.fillParent()
    }
}

extension CurrencyPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
}
