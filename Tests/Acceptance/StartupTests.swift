//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

@testable import CitySearch

import Foundation
import UIKit

class StartupTests : BDDTest<StartupSteps> {

    func testShowStartupOnLaunch() {

        when.appLaunches()

        then.startupScreenAppearsFullScreen()
    }
}

final class StartupSteps: Steps {

    let appDelegate = AppDelegate()

    func appLaunches() {
        
        appDelegate.applicationDidFinishLaunching(UIApplication.shared)
    }

    func startupScreenAppearsFullScreen() {

        let window = appDelegate.window

        XCTAssertTrue(window.isKeyWindow, "AppDelegate window is not key window")

        guard let rootController = window.rootViewController else {
            XCTFail("Application window does not have root view controller after launch")
            return
        }

        XCTAssertTrue(rootController is StartupController, "Root controller's is not StartupScreen")
    }
}