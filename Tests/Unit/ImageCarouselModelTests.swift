//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class ImageCarouselModelTests: XCTestCase {

    var steps: ImageCarouselModelSteps!

    var given: ImageCarouselModelSteps { steps }
    var when: ImageCarouselModelSteps { steps }
    var then: ImageCarouselModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = ImageCarouselModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testObserveSearchResultsImmediate() {

        let imageModelsObservable = given.imageModelsObservable()
        let searchModel = given.imageURLsModelCreated(imageModels: imageModelsObservable)
        let observer = given.resultsObserver()

        when.observeSearchResults(searchModel, observer)

        then.observerIsNotifiedImmediately(observer)
    }

    func testObserveSearchResultsUpdate() {

        let imageModelsObservable = given.imageModelsObservable()
        let imageModels = given.imageModels()
        let searchModel = given.imageURLsModelCreated(imageModels: imageModelsObservable)
        let observer = given.resultsObserver()
        given.observeSearchResults(searchModel, observer)

        when.imageModels(imageModelsObservable, isUpdatedTo: imageModels)

        then.observerIsNotified(observer, ofNewValue: imageModels)
    }

    func testSetResults() {

        let imageURLs = given.imageURLs()
        let expectedResultModels = given.models(for: imageURLs)
        let imageModels = given.imageModelsObservable()
        let searchModel = given.imageURLsModelCreated(imageModels: imageModels)

        when.setResults(searchModel, imageURLs)

        // Good example of the same step being a "when" in one test (the previous one) and a "then" in another test (this one).  Making something happen isn't the same as checking that it did happen, so I made a slightly renamed function.  There are other ways to handle this, like separating the assertions into another class (but then you have to deal with passing state between these classes)
        then.imageModels(imageModels, isSetTo: expectedResultModels)
    }
}

class ImageCarouselModelSteps {

    private let imageModelFactory = AsyncImageModelFactoryMock()

    private var valuePassedToObserver: [AsyncImageModel]?

    private var listenerPassedToObservable: ValueUpdate<[AsyncImageModel]>?
    private var listenerIsNotifiedImmediately = false

    private var imageModelsValue: [AsyncImageModel] = []

    init() {

        var modelsMap: [URL : AsyncImageModelMock] = [:]
        imageModelFactory.imageModelImp = { url in

            let model = modelsMap[url] ?? {

                let result = AsyncImageModelMock()
                modelsMap[url] = result
                return result
            }()

            return model
        }
    }

    func imageModelsObservable() -> ObservableMock<[AsyncImageModel]> {

        let imageModels = ObservableMock<[AsyncImageModel]>([])

        imageModels.subscribeImp = { (listener, updateImmediately) in

            self.listenerPassedToObservable = listener
            self.listenerIsNotifiedImmediately = updateImmediately
        }

        imageModels.valueSetter = { (newValue) in

            self.imageModelsValue = newValue
        }

        return imageModels
    }

    func imageURLs() -> [URL] {

        (0..<5).map({ index in URL(string: "https://\(index)")!})
    }

    func imageModels() -> [AsyncImageModelMock] {

        (0..<5).map({ _ in AsyncImageModelMock() })
    }

    func models(for imageURLs: [URL]) -> [AsyncImageModelMock] {

        imageURLs.map( { imageModelFactory.imageModel(for: $0) as! AsyncImageModelMock } )
    }

    func resultsObserver() -> ValueUpdate<[AsyncImageModel]> {

        { (value) in

            self.valuePassedToObserver = value
        }
    }

    func imageURLsModelCreated(imageModels: ObservableMock<[AsyncImageModel]> = ObservableMock<[AsyncImageModel]>([])) -> ImageCarouselModelImp {

        ImageCarouselModelImp(modelFactory: imageModelFactory, imageModels: imageModels)
    }

    func imageURLsModel(_ imageURLsModel: ImageCarouselModelImp, dataIsSetTo imageURLs: [URL]) {

        imageURLsModel.setResults(imageURLs)
    }

    func imageModels(_ imageModelsObservable: ObservableMock<[AsyncImageModel]>, isUpdatedTo imageModels: [AsyncImageModel]) {

        listenerPassedToObservable?(imageModels)
    }

    func observeSearchResults(_ model: ImageCarouselModelImp, _ observer: @escaping ValueUpdate<[AsyncImageModel]>) {

        model.observeResultsModels(observer)
    }

    func setResults(_ model: ImageCarouselModelImp, _ results: [URL]) {

        model.setResults(results)
    }

    func observerIsNotifiedImmediately(_ observer: ValueUpdate<[AsyncImageModel]>) {

        XCTAssertTrue(listenerIsNotifiedImmediately, "Observer was not notified immediately")
    }

    func observerIsNotified(_ observer: ValueUpdate<[AsyncImageModel]>, ofNewValue newValue: [AsyncImageModel]) {

        XCTAssertTrue(valuePassedToObserver?.elementsEqual(newValue) { (firstModel, secondModel) in firstModel === secondModel } ?? false, "Observer was not notified of correct results")
    }

    func imageModels(_ imageModels: ObservableMock<[AsyncImageModel]>, isSetTo expectedResults: [AsyncImageModelMock]) {

        XCTAssertTrue(imageModelsValue.elementsEqual(expectedResults) { (firstModel, secondModel) in firstModel === secondModel }, "Result models was not set to expected value")
    }
}