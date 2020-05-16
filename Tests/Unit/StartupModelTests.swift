//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class StartupModelTests: XCTestCase {

    var steps: StartupModelSteps!

    var given: StartupModelSteps { steps }
    var when: StartupModelSteps { steps }
    var then: StartupModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = StartupModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testBindAppTitleText() {

        let appTitleText = given.appTitleText()
        let model = given.model(appTitleText)
        let textUpdate = given.textUpdate()

        when.observerAppTitleText(model, textUpdate)

        then.textUpdateIsCalled(textUpdate)
    }
}

class StartupModelSteps {

    private var textUpdateCalled = false

    func appTitleText() -> ObservableMock<String> {

        let appTitleText = ObservableMock<String>()

        appTitleText.subscribeImp = { (listener, updateImmediately) in

            if updateImmediately {

                listener("")
            }
        }

        return appTitleText
    }

    func model(_ appTitleText: ObservableMock<String>) -> StartupModelImp {

        StartupModelImp(appTitleText: appTitleText)
    }

    func textUpdate() -> ValueUpdate<String> {

        { (text) in

            self.textUpdateCalled = true
        }
    }

    func observerAppTitleText(_ model: StartupModelImp, _ textUpdate: @escaping ValueUpdate<String>) {

        model.observeAppTitleText(textUpdate)
    }

    func textUpdateIsCalled(_ textUpdate: ValueUpdate<String>) {

        XCTAssertTrue(textUpdateCalled, "Text update was not called")
    }
}