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
        let labelUpdate = given.bindLabelData(binder, label)
        let text = given.text()

        when.updateText(labelUpdate, text)

        then.label(label, textEquals: text)
    }

    func testBindLabelFont() {

        let label = given.label()
        let binder = given.binder()
        let labelUpdate = given.bindLabelData(binder, label)
        let font = given.font()

        when.updateFont(labelUpdate, font)

        then.label(label, fontEquals: font)
    }

    func testBindImageViewImage() {

        let imageView = given.imageView()
        let binder = given.binder()
        let imageUpdate = given.bindImageViewImage(binder, imageView)
        let image = given.image()

        when.updateImage(imageUpdate, image)

        then.imageView(imageView, imageEquals: image)
    }

    func testBindViewFrame() {

        let parentView = given.parentView()
        let view = given.view(in: parentView)
        let binder = given.binder()
        let frameUpdate = given.bindViewFrame(binder, view)
        let frame = given.frame()

        when.updateFrame(frameUpdate, frame)

        then.view(view, isConstrainedToFrame: frame, in: parentView)
    }
}

class ViewBinderSteps {

    func label() -> UILabel {

        UILabel()
    }

    func imageView() -> UIImageView {

        UIImageView()
    }

    func parentView() -> UIView {

        UIView()
    }

    func view(in parent: UIView) -> UIView {

        let view = UIView()
        parent.addSubview(view)
        return view
    }

    func binder() -> ViewBinderImp {

        ViewBinderImp()
    }

    func bindLabelData(_ binder: ViewBinderImp, _ label: UILabel) -> ValueUpdate<LabelViewModel> {

        binder.bindText(label: label)
    }

    func bindImageViewImage(_ binder: ViewBinderImp, _ imageView: UIImageView) -> ValueUpdate<UIImage> {

        binder.bindImage(imageView: imageView)
    }

    func bindViewFrame(_ binder: ViewBinderImp, _ view: UIView) -> ValueUpdate<CGRect> {

        binder.bindFrame(view: view)
    }

    func text() -> String {

        "textText"
    }

    func font() -> UIFont {

        UIFont.systemFont(ofSize: 43.4)
    }

    func image() -> UIImage {

        UIImageMock()
    }

    func frame() -> CGRect {

        CGRect(x: 24.0, y: 21.0, width: 60.0, height: 35.0)
    }

    func updateText(_ labelUpdate: ValueUpdate<LabelViewModel>, _ text: String) {

        labelUpdate(LabelViewModel(text: text, font: .systemFont(ofSize: 12.0)))
    }

    func updateFont(_ labelUpdate: ValueUpdate<LabelViewModel>, _ font: UIFont) {

        labelUpdate(LabelViewModel(text: "", font: font))
    }

    func updateImage(_ imageUpdate: ValueUpdate<UIImage>, _ image: UIImage) {

        imageUpdate(image)
    }

    func updateFrame(_ frameUpdate: ValueUpdate<CGRect>, _ frame: CGRect) {

        frameUpdate(frame)
    }

    func label(_ label: UILabel, textEquals expectedText: String) {

        XCTAssertEqual(label.text, expectedText, "Text update did not update bound label text")
    }

    func label(_ label: UILabel, fontEquals expectedFont: UIFont) {

        XCTAssertEqual(label.font, expectedFont, "Text update did not update bound label font")
    }

    func imageView(_ imageView: UIImageView, imageEquals expectedImage: UIImage) {

        XCTAssertTrue(imageView.image === expectedImage, "Image update did not update bound image view")
    }

    func view(_ view: UIView, isConstrainedToFrame expectedFrame: CGRect, in parent: UIView) {

        let expectedConstraints = [view.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: expectedFrame.origin.x),
                                   view.topAnchor.constraint(equalTo: parent.topAnchor, constant: expectedFrame.origin.y),
                                   view.widthAnchor.constraint(equalToConstant: expectedFrame.size.width),
                                   view.heightAnchor.constraint(equalToConstant: expectedFrame.size.height)]

        ViewConstraintValidator.validateThatView(parent, hasConstraints: expectedConstraints, message: "Frame update did not constrain view to frame")
    }
}
