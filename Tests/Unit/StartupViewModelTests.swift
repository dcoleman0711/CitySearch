//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class StartupViewModelTests: XCTestCase {

    var steps: StartupViewModelSteps!

    var given: StartupViewModelSteps { steps }
    var when: StartupViewModelSteps { steps }
    var then: StartupViewModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = StartupViewModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testObserveAppTitleText() {

        let appTitle = given.appTitle()
        let model = given.model(appTitle)
        let viewModel = given.viewModel(model)
        let textUpdate = given.textUpdate()

        when.observerAppTitleText(viewModel, textUpdate)

        then.appTitleTextIsUpdated(textUpdate, toValue: appTitle)
    }

    func testObserveAppTitleFont() {

        let font = given.appTitleFont()
        let model = given.model()
        let viewModel = given.viewModel(model)
        let textUpdate = given.textUpdate()

        when.observerAppTitleText(viewModel, textUpdate)

        then.appTitleTextFontIsUpdated(textUpdate, toValue: font)
    }
}

class StartupViewModelSteps {

    private var updatedText: String?
    private var observedAppTitle: LabelViewModel?

    func appTitle() -> String {

        "Test Title"
    }

    func appTitleFont() -> UIFont {

        StartupScreenTestConstants.appTitleFont
    }

    func viewModel(_ model: StartupModelMock = StartupModelMock()) -> StartupViewModelImp {

        StartupViewModelImp(model: model)
    }

    func model(_ appTitle: String = "") -> StartupModelMock {

        let model = StartupModelMock()

        model.observeAppTitleTextImp = { (textUpdate) in

            textUpdate(appTitle)
        }

        return model
    }

    func textUpdate() -> ValueUpdate<LabelViewModel> {

        { (viewModel) in

            self.observedAppTitle = viewModel
        }
    }

    func observerAppTitleText(_ viewModel: StartupViewModelImp, _ textUpdate: @escaping ValueUpdate<LabelViewModel>) {

        viewModel.observeAppTitle(textUpdate)
    }

    func appTitleTextIsUpdated(_ textUpdate: ValueUpdate<LabelViewModel>, toValue expectedText: String) {

        XCTAssertEqual(observedAppTitle?.text, expectedText, "App title text was not updated correctly")
    }

    func appTitleTextFontIsUpdated(_ valueUpdate: ValueUpdate<LabelViewModel>, toValue expectedFont: UIFont) {

        XCTAssertEqual(observedAppTitle?.font, expectedFont, "App title font was not updated correctly")
    }
}