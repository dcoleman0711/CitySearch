//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class ImageServiceTests: XCTestCase {

    var steps: ImageServiceSteps!

    var given: ImageServiceSteps { steps }
    var when: ImageServiceSteps { steps }
    var then: ImageServiceSteps { steps }

    override func setUp() {

        super.setUp()

        steps = ImageServiceSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testImageFetchResponse() {

        let url = given.url()
        let image = given.image()
        let urlSession = given.urlSession()
        given.urlSession(urlSession, returnsResponse: image, for: url)
        let searchService = given.searchService(urlSession)

        let results = when.perform(searchService, url)

        then.result(results, isEqualTo: image)
    }
}

class ImageServiceSteps {

    private var receivedResult: UIImage?

    func url() -> URL {

        URL(string: "https//")!
    }

    func image() -> UIImage {

        ImageLoader.loadImage(name: "TestImage.jpg")!
    }

    func urlSession() -> URLSessionMock {

        URLSessionMock()
    }

    func urlSession(_ urlSession: URLSessionMock, returnsResponse image: UIImage, for url: URL) {

        urlSession.dataTaskImp = { (request, completionHandler) in

            let dataTask = URLSessionDataTaskMock()

            dataTask.resumeImp = {

                completionHandler(image.pngData()!, HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
            }

            return dataTask
        }
    }

    func searchService(_ urlSession: URLSessionMock) -> ImageServiceImp {

        ImageServiceImp(urlSession: urlSession)
    }

    func perform(_ searchService: ImageServiceImp, _ url: URL) -> UIImage? {

        let result = searchService.fetchImage(url)
        result.sink(receiveCompletion: { error in  }, receiveValue: { result in
            self.receivedResult = result
        })

        return self.receivedResult
    }

    func result(_ result: UIImage?, isEqualTo expectedResult: UIImage) {

        XCTAssertTrue(result?.isSameImageAs(expectedResult) ?? false, "Result is not the expected result")
    }
}

extension UIImage {

    func isSameImageAs(_ other: UIImage) -> Bool {

        guard let png = self.pngData(), let otherPng = other.pngData() else { return self.isEqual(other) }

        return png == otherPng
    }
}