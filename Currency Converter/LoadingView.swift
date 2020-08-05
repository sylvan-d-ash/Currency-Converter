//
//  LoadingView.swift
//  Currency Converter
//
//  Created by Sylvan Ash on 05/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    private var parentView: UIView?
    private var terminated = false
    var activityIndicator: UIActivityIndicatorView!
    var shown = false

    /**
     Initialization

     - parameter parentView: parent view to display loader in
     - parameter dimming: flag - whether should be dimmed
     - parameter whiten: flag - whether should have light or dark background
     */
    init(_ parentView: UIView?, dimming: Bool = true, whiten: Bool = false) {
        if let parentView = parentView {
            parentView.layoutIfNeeded()
        }

        super.init(frame: parentView?.bounds ?? UIScreen.main.bounds)
        self.parentView = parentView
        setupView(dimming: dimming, whiten: whiten)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Setup the view

     - parameter dimming: dimming state
     - parameter whiten: background state of view. If true, use white else use dark
     */
    fileprivate func setupView(dimming: Bool, whiten: Bool = false) {

        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.center
        self.addSubview(activityIndicator)

        if whiten {
            self.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.55)
            activityIndicator.style = .medium

        } else {
            if dimming {
                self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.55)
                activityIndicator.style = .medium

            } else {
                self.backgroundColor = UIColor.clear
            }
        }

        self.alpha = 0.0
    }

    func terminate() {
        terminated = true
        guard shown else { return }

        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0.0
        }) { success in
            self.activityIndicator.stopAnimating()
            self.removeFromSuperview()
        }
    }

    func show() -> LoadingView {
        shown = true

        if !terminated {
            if let view = parentView {
                view.addSubview(self)
                return self
            }

            UIApplication.shared.delegate!.window!?.addSubview(self)
        }

        return self
    }

    /**
     Start animating when the loading view moves to superview
     */
    override func didMoveToSuperview() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0.75
        })
    }
}
