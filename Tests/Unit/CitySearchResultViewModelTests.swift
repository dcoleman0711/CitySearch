//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class CitySearchResultViewModelTests: XCTestCase {

    var steps: CitySearchResultViewModelSteps!

    var given: CitySearchResultViewModelSteps { steps }
    var when: CitySearchResultViewModelSteps { steps }
    var then: CitySearchResultViewModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = CitySearchResultViewModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testTitle() {

        let titleText = given.titleText()
        let model = given.model(titleText: titleText)

        let viewModel = when.viewModelIsCreated(model: model)

        then.viewModel(viewModel, textIs: titleText)
    }

    func testIcon() {

        let populationClass = given.populationClass()
        let model = given.model(populationClass: populationClass)
        let icon = given.icon(for: populationClass)
        let imageObserver = given.imageObserver()
        let viewModel = given.viewModelIsCreated(model: model)

        when.observer(imageObserver, observesIconIn: viewModel)

        then.observer(imageObserver, receivedValue: icon)
    }

    func testTapCommand() {

        let tapCommand = given.tapCommand()
        let model = given.model(tapCommand: tapCommand)

        let viewModel = when.viewModelIsCreated(model: model)

        then.viewModel(viewModel, tapCommandIs: tapCommand)
    }
}

class CitySearchResultViewModelSteps {

    private var observedImage: UIImage?

    func titleText() -> String {

        "Test Title"
    }

    func populationClass() -> PopulationClass {

        PopulationClassMedium()
    }

    func imageObserver() -> ValueUpdate<UIImage> {

        { image in

            self.observedImage = image
        }
    }

    func tapCommand() -> OpenDetailsCommandMock {

        OpenDetailsCommandMock()
    }

    func observer(_ imageObserver: @escaping ValueUpdate<UIImage>, observesIconIn viewModel: CitySearchResultViewModelImp) {

        viewModel.observeIconImage(imageObserver)
    }

    func model(titleText: String = "", populationClass: PopulationClass = PopulationClassSmall(), tapCommand: OpenDetailsCommandMock = OpenDetailsCommandMock()) -> CitySearchResultModelMock {

        let model = CitySearchResultModelMock()

        model.titleText = titleText
        model.populationClass = populationClass

        model.tapCommand = tapCommand

        return model
    }

    func icon(for populationClass: PopulationClass) -> UIImage {

        class ImageSelector: PopulationClassVisitor {

            typealias T = UIImage

            func visitSmall(_ class: PopulationClassSmall) -> UIImage { ImageLoader.loadImage(name: "City1")! }
            func visitMedium(_ class: PopulationClassMedium) -> UIImage { ImageLoader.loadImage(name: "City2")! }
            func visitLarge(_ class: PopulationClassLarge) -> UIImage { ImageLoader.loadImage(name: "City3")! }
            func visitVeryLarge(_ class: PopulationClassVeryLarge) -> UIImage { ImageLoader.loadImage(name: "City4")! }
        }

        return populationClass.accept(ImageSelector())
    }

    func viewModelIsCreated(model: CitySearchResultModelMock) -> CitySearchResultViewModelImp {

        CitySearchResultViewModelFactoryImp().resultViewModel(model: model) as! CitySearchResultViewModelImp
    }

    func viewModel(_ viewModel: CitySearchResultViewModelImp, textIs expectedText: String) {

        XCTAssertEqual(viewModel.titleData.text, expectedText, "Title text is not correct")
    }

    func viewModel(_ viewModel: CitySearchResultViewModelImp, tapCommandIs expectedCommand: OpenDetailsCommandMock) {

        XCTAssertTrue(viewModel.tapCommand === expectedCommand, "Tap command is not correct")
    }

    func observer(_ observer: @escaping ValueUpdate<UIImage>, receivedValue icon: UIImage) {

        XCTAssertTrue(UIImage.compareImages(lhs: observedImage, rhs: icon), "Icon Observer did not receive correct image")
    }
}