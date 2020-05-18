//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class ViewBinderTests: XCTestCase {

    var steps: ViewBinderSteps!

    var given: ViewBinderSteps { steps }
    var when: ViewBinderSteps { steps }
    var then: ViewBinderSteps { steps }

    override func setUp() {

        super.setUp()

        steps = ViewBinderSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testBindLabelText() {

        let label = given.label()
        let binder = given.binder()
        let textUpdate = given.bindLabelText(binder, label)
        let text = given.text()

        when.updateText(textUpdate, text)

        then.label(label, textEquals: text)
    }
}

class ViewBinderSteps {

    func label() -> UILabel {

        UILabel()
    }

    func binder() -> ViewBinderImp {

        ViewBinderImp()
    }

    func bindLabelText(_ binder: ViewBinderImp, _ label: UILabel) -> ValueUpdate<LabelViewModel> {

        binder.bindText(label: label)
    }

    func text() -> String {

        "textText"
    }

    func updateText(_ textUpdate: ValueUpdate<LabelViewModel>, _ text: String) {

        textUpdate(LabelViewModel(text: text, font: UIFont()))
    }

    func label(_ label: UILabel, textEquals expectedText: String) {

        XCTAssertEqual(label.text, expectedText, "Text update did not update bound label")
    }
}