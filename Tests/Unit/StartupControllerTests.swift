//
//  StartupControllerTests.swift
//  CitySearchTests
//
//  Created by Daniel Coleman on 5/15/20.
//  Copyright © 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class StartupControllerTests: XCTestCase {

    var steps: StartupControllerSteps!

    var given: StartupControllerSteps { steps }
    var when: StartupControllerSteps { steps }
    var then: StartupControllerSteps { steps }

    override func setUp() {

        super.setUp()

        steps = StartupControllerSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }
    
    func testStartupControllerAssignsView() {

        let view = given.view()
        let startupView = given.startupView(view)
        let startupController = given.startupController(startupView)

        when.startupControllerLoads(startupController)

        then.startupController(startupController, viewIs: startupView)
    }
}

class StartupControllerSteps {

    let stubView = UIView()

    func view() -> UIView {

        stubView
    }

    func startupController(_ startupView: StartupViewMock) -> StartupController {

        StartupController(startupView: startupView)
    }

    func startupView(_ view: UIView) -> StartupViewMock {

        let startupView = StartupViewMock()

        startupView.viewGetter = { view }

        return startupView
    }

    func startupControllerLoads(_ startupController: StartupController) {

        startupController.loadViewIfNeeded()
    }

    func startupController(_ startupController: StartupController, viewIs startupView: StartupViewMock) {

        XCTAssertEqual(startupController.view, stubView)
    }
}
