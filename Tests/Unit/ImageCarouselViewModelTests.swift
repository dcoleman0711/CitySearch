//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class ImageCarouselViewModelTests: XCTestCase {

    var steps: ImageCarouselViewModelSteps!

    var given: ImageCarouselViewModelSteps { steps }
    var when: ImageCarouselViewModelSteps { steps }
    var then: ImageCarouselViewModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = ImageCarouselViewModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testObserveSearchResultsImmediate() {

        let model = given.imageCarouselModel()
        let viewModel = given.imageCarouselViewModelIsCreated(model: model)
        let resultModels = given.resultModels()
        let resultViewModels = given.resultViewModels(for: resultModels)
        let resultsData = given.resultsData(for: resultViewModels)
        let observer = given.resultsObserver()
        given.model(model, updatedResultsTo: resultModels)

        when.observeSearchResults(viewModel, observer)

        then.observer(observer, isNotifiedWith: resultsData)
    }

    func testObserveSearchResultsUpdate() {

        let model = given.imageCarouselModel()
        let viewModel = given.imageCarouselViewModelIsCreated(model: model)
        let resultModels = given.resultModels()
        let resultViewModels = given.resultViewModels(for: resultModels)
        let resultsData = given.resultsData(for: resultViewModels)
        let observer = given.resultsObserver()
        given.observeSearchResults(viewModel, observer)

        when.model(model, updatedResultsTo: resultModels)

        then.observer(observer, isNotifiedWith: resultsData)
    }
}

class ImageCarouselViewModelSteps {

    private let resultViewModelFactory = AsyncImageViewModelFactoryMock()

    private var valuePassedToObserver: [CellData<AsyncImageViewModel>]?
    private var modelObserver: ValueUpdate<[AsyncImageModel]>?

    private var images: [ObjectIdentifier: UIImageMock] = [:]

    func resultViewModels(for resultModels: [AsyncImageModelMock]) -> [AsyncImageViewModelMock] {

        var viewModelsMap: [ObjectIdentifier : AsyncImageViewModelMock] = [:]
        resultViewModelFactory.viewModelImp = { (model) in

            let modelID = ObjectIdentifier(model)
            let viewModel: AsyncImageViewModelMock = viewModelsMap[modelID] ?? {

                let result = AsyncImageViewModelMock()
                viewModelsMap[modelID] = result
                return result
            }()

            let viewModelID = ObjectIdentifier(viewModel)
            let image: UIImageMock = self.images[viewModelID] ?? {

                let aspectRatio = 1.5
                let imageHeight = 64.0
                let size = CGSize(width: aspectRatio * imageHeight, height: imageHeight)

                let image = UIImageMock()
                image.sizeMock = size

                self.images[viewModelID] = image

                return image
            }()

            viewModel.observeImageImp = { observer in observer(image) }

            return viewModel
        }

        return resultModels.map( { resultViewModelFactory.viewModel(model: $0) as! AsyncImageViewModelMock } )
    }

    func resultsObserver() -> ValueUpdate<[CellData<AsyncImageViewModel>]> {

        { (value) in

            self.valuePassedToObserver = value
        }
    }

    func imageCarouselViewModelIsCreated(model: ImageCarouselModelMock) -> ImageCarouselViewModelImp {

        ImageCarouselViewModelImp(model: model, viewModelFactory: resultViewModelFactory)
    }

    func imageCarouselModel() -> ImageCarouselModelMock {

        let model = ImageCarouselModelMock()

        model.observeResultsModelsImp = { (observer) in

            self.modelObserver = observer
        }

        return model
    }

    func model(_ model: ImageCarouselModelMock, updatedResultsTo resultModels: [AsyncImageModelMock]) {

        modelObserver?(resultModels)
    }

    func resultModels() -> [AsyncImageModelMock] {

        (0..<5).map({ _ in AsyncImageModelMock() })
    }

    func resultsData(for viewModels: [AsyncImageViewModel]) -> [CellData<AsyncImageViewModel>] {

        viewModels.map({ viewModel in

            let image = images[ObjectIdentifier(viewModel)]!
            let aspectRatio = image.size.width / image.size.height
            let cellHeight: CGFloat = 256.0
            let cellSize = CGSize(width: aspectRatio * cellHeight, height: cellHeight)

            return CellData<AsyncImageViewModel>(viewModel: viewModel, size: cellSize, tapCommand: nil)
        })
    }

    func observeSearchResults(_ viewModel: ImageCarouselViewModelImp, _ observer: @escaping ValueUpdate<[CellData<AsyncImageViewModel>]>) {

        viewModel.observeResults(observer)
    }

    func observer(_ observer: ValueUpdate<[CellData<AsyncImageViewModel>]>, isNotifiedWith expectedResults: [CellData<AsyncImageViewModel>]) {

        XCTAssertTrue(valuePassedToObserver?.elementsEqual(expectedResults) { first, second in first.viewModel === second.viewModel && first.size == second.size } ?? false, "Observer was not notified of correct results")
    }
}

class UIImageMock: UIImage {

    var sizeMock = CGSize.zero
    override var size: CGSize { sizeMock }
}