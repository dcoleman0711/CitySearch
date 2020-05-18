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

    func bindLabelText(_ binder: ViewBinderImp, _ label: UILabel) -> ValueUpdate<NSAttributedString> {

        binder.bindText(label: label)
    }

    func text() -> NSAttributedString {

        NSAttributedString(string: "textText")
    }

    func updateText(_ textUpdate: ValueUpdate<NSAttributedString>, _ text: NSAttributedString) {

        textUpdate(text)
    }

    func label(_ label: UILabel, textEquals expectedText: NSAttributedString) {

        XCTAssertEqual(label.attributedText, expectedText, "Text update did not update bound label")
    }
}