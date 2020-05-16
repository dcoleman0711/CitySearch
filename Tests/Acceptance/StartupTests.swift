//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

@testable import CitySearch

import Foundation
import UIKit

class StartupTests : XCTestCase {
    
    var steps: StartupSteps!

    var given: StartupSteps { steps }
    var when: StartupSteps { steps }
    var then: StartupSteps { steps }

    override func setUp() {

        super.setUp()

        steps = StartupSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }
    
    func testShowStartupOnLaunch() {

        when.appLaunches()

        then.startupScreenAppearsFullScreen()
    }
}

class StartupSteps {

    let appDelegate = AppDelegate()

    func appLaunches() {
        
        appDelegate.applicationDidFinishLaunching(UIApplication.shared)
    }

    func startupScreenAppearsFullScreen() {

        guard let window = appDelegate.window else {
            XCTFail("AppDelegate window is nil")
            return
        }

        XCTAssertTrue(window.isKeyWindow, "AppDelegate window is not key window")

        guard let rootController = window.rootViewController else {
            XCTFail("Application window does not have root view controller after launch")
            return
        }

        XCTAssertTrue(rootController is StartupController, "Root controller's is not StartupScreen")
    }
}
