//
//  MainPresenterTests.swift
//  Currency ConverterTests
//
//  Created by Sylvan Ash on 06/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import XCTest
@testable import Currency_Converter

class MainPresenterTests: XCTestCase {
    var sut: MainPresenter!
    var view: MainViewSpy!
    var interactor: MainInteractorMock!

    override func setUpWithError() throws {
        view = MainViewSpy()
        interactor = MainInteractorMock()
        sut = MainPresenter(view: view, interactor: interactor)
    }

    override func tearDownWithError() throws {
        sut = nil
        interactor = nil
        view = nil
    }

    func testViewDidLoadSuccess() throws {
        //
    }

    func testViewDidLoadFailure() throws {
        //
    }

    func testPickerViewWithNoCurrencies() throws {
        //
    }

    func testPickerViewWithCurrencies() throws {
        //
    }

    func testCurrencySelected() throws {
        //
    }

    func testValueChanged() throws {
        //
    }

    func testConfiguringCell() throws {
        //
    }
}
