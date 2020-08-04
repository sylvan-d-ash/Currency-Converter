//
//  MainViewController.swift
//  Currency Converter
//
//  Created by Sylvan Ash on 04/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private let firstCurrencyButton = UIButton()
    private let secondCurrencyButton = UIButton()
    private let swapCurrenciesButton = UIButton()
    private let firstCurrencyTextfield = UITextField()
    private let secondCurrencyTextfield = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

private extension MainViewController {
    func setupSubviews() {
        view.backgroundColor = .green

        let swapImageView = UIImageView(image: UIImage(named: ""))
        let swapView = UIView()
        [swapImageView, swapCurrenciesButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            swapView.addSubview($0)

            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: swapView.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: swapView.trailingAnchor),
                $0.topAnchor.constraint(equalTo: swapView.topAnchor),
                $0.bottomAnchor.constraint(equalTo: swapView.bottomAnchor),
            ])
        }
        swapImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        swapImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let headerView = UIView()
        [firstCurrencyButton, swapView, secondCurrencyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview($0)

            $0.backgroundColor = .orange

            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: headerView.topAnchor),
                $0.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            ])
        }
        NSLayoutConstraint.activate([
            firstCurrencyButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            swapView.leadingAnchor.constraint(equalTo: firstCurrencyButton.trailingAnchor, constant: 10),
            secondCurrencyButton.leadingAnchor.constraint(equalTo: swapView.trailingAnchor, constant: 10),
            secondCurrencyButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            firstCurrencyButton.widthAnchor.constraint(equalTo: secondCurrencyButton.widthAnchor, multiplier: 1),
        ])
        swapView.backgroundColor = .brown

        [firstCurrencyTextfield, secondCurrencyTextfield].forEach {
            $0.keyboardType = .decimalPad
            $0.backgroundColor = .blue
        }

        let textfieldsStackview = UIStackView(arrangedSubviews: [firstCurrencyTextfield, secondCurrencyTextfield])
        textfieldsStackview.axis = .horizontal
        textfieldsStackview.spacing = 30
        textfieldsStackview.distribution = .fillEqually

        let stackview = UIStackView(arrangedSubviews: [headerView, textfieldsStackview])
        stackview.axis = .vertical
        stackview.spacing = 10
        stackview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackview)
        NSLayoutConstraint.activate([
            stackview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
}
