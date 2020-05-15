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

        let startupController = given.startupController()
        let startupView = given.startupView(startupController)

        when.startupControllerLoads(startupController)

        then.startupController(startupController, viewIs: startupView)
    }
}

class StartupControllerSteps {

    func startupController() -> StartupController {

        StartupController()
    }

    func startupView(_ startupController: StartupController) -> StartupView {

        startupController.startupView
    }

    func startupControllerLoads(_ startupController: StartupController) {

        startupController.loadViewIfNeeded()
    }

    func startupController(_ startupController: StartupController, viewIs startupView: StartupView) {

        XCTAssertEqual(startupController.view, startupView.view)
    }
}
