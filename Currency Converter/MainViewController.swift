//
//  MainViewController.swift
//  Currency Converter
//
//  Created by Sylvan Ash on 04/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private let firstCurrencyButton = UIButton(type: .system)
    private let secondCurrencyButton = UIButton(type: .system)
    private let swapCurrenciesButton = UIButton(type: .system)
    private let firstCurrencyTextfield = UITextField()
    private let secondCurrencyTextfield = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

private extension MainViewController {
    enum Dimensions {
        static let spacing: CGFloat = 10
        static let swapButtonWidth: CGFloat = 50
        static let swapButtonHeight: CGFloat = 40
    }

    func setupSubviews() {
        view.backgroundColor = .white

        let swapImageView = UIImageView(image: UIImage(named: "icon-exchange"))
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
        swapImageView.widthAnchor.constraint(equalToConstant: Dimensions.swapButtonWidth).isActive = true
        swapImageView.heightAnchor.constraint(equalToConstant: Dimensions.swapButtonHeight).isActive = true

        let headerView = UIView()
        [firstCurrencyButton, swapView, secondCurrencyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview($0)

            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: headerView.topAnchor),
                $0.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            ])
        }
        NSLayoutConstraint.activate([
            firstCurrencyButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            swapView.leadingAnchor.constraint(equalTo: firstCurrencyButton.trailingAnchor, constant: Dimensions.spacing),
            secondCurrencyButton.leadingAnchor.constraint(equalTo: swapView.trailingAnchor, constant:  Dimensions.spacing),
            secondCurrencyButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            firstCurrencyButton.widthAnchor.constraint(equalTo: secondCurrencyButton.widthAnchor, multiplier: 1),
        ])

        [firstCurrencyTextfield, secondCurrencyTextfield].forEach {
            $0.keyboardType = .decimalPad
            $0.borderStyle = .roundedRect
        }

        let textfieldsStackview = UIStackView(arrangedSubviews: [firstCurrencyTextfield, secondCurrencyTextfield])
        textfieldsStackview.axis = .horizontal
        textfieldsStackview.spacing = Dimensions.swapButtonWidth + (2 * Dimensions.spacing)
        textfieldsStackview.distribution = .fillEqually

        let stackview = UIStackView(arrangedSubviews: [headerView, textfieldsStackview])
        stackview.axis = .vertical
        stackview.spacing = Dimensions.spacing
        stackview.distribution = .fillEqually
        stackview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackview)
        NSLayoutConstraint.activate([
            stackview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.spacing),
            stackview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.spacing),
            stackview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Dimensions.swapButtonHeight),
        ])

        setDefaults()
    }

    func setDefaults() {
        firstCurrencyButton.setTitle("US Dollar", for: .normal)
        secondCurrencyButton.setTitle("Euro", for: .normal)
    }
}
