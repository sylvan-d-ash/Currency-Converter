//
//  CurrencyPickerView.swift
//  Currency Converter
//
//  Created by Sylvan Ash on 05/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

protocol CurrencyPickerViewDelegate: AnyObject {
    func didSelect(currency: String)
}

class CurrencyPickerView: UIView {
    private let pickerView = UIPickerView(frame: .zero)
    private var currencies: [String] = []
    private var selectedCurrency: String = ""
    weak var delegate: CurrencyPickerViewDelegate?

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
        // TODO: improve on design
        // - change background to white
        // - add top shadow
        // - separator line between done button and pickerview

        backgroundColor = .clear

        let dimView = UIView()
        dimView.backgroundColor = .gray
        dimView.alpha = 0.7
        addSubview(dimView)
        dimView.fillParent()

        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pickerView)

        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 35),

            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @objc func doneTapped() {
        delegate?.didSelect(currency: selectedCurrency)
        hide()
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

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencies[row]
    }
}
