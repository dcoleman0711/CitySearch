//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class ImageSearchServiceTests: XCTestCase {

    var steps: ImageSearchServiceSteps!

    var given: ImageSearchServiceSteps { steps }
    var when: ImageSearchServiceSteps { steps }
    var then: ImageSearchServiceSteps { steps }

    override func setUp() {

        super.setUp()

        steps = ImageSearchServiceSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testImageSearchRequest() {

        let query = given.query()
        let url = given.searchUrl(for: query)
        let urlSession = given.urlSession()
        let searchService = given.searchService(urlSession)

        when.perform(searchService, query)

        then.searchService(searchService, requestedURL: url)
    }

    func testImageSearchResponse() {

        let query = given.query()
        let httpResponse = given.httpResponse()
        let urlSession = given.urlSession()
        given.urlSession(urlSession, returnsResponse: httpResponse)
        let expectedResults = given.expectedResults()
        let searchService = given.searchService(urlSession)

        let results = when.perform(searchService, query)

        then.results(results, areEqualTo: expectedResults)
    }
}

class ImageSearchServiceSteps {

    private var requestedURL: URL?

    private var receivedResult: ImageSearchResults?

    private var responseData = Data()

    func query() -> String {

        "searchQuery"
    }

    func searchUrl(for query: String) -> URL {

        // This isn't foolproof, because the query parameters can be reordered and it is still the "same"
        URL(string: "https://serpapi.com/search?api_key=7a28f042f0a5f2a8d3444fd64a074bceee47f5837f7ee953ee255ddc5640de3b&q=searchQuery&tbm=isch&ijn=0")!
    }

    func httpResponse() -> Data {

        let stubResponseFile = Bundle(for: ImageSearchServiceSteps.self).url(forResource: "stubImageResponse", withExtension: "json")!
        return try! Data(contentsOf: stubResponseFile)
    }

    func urlSession() -> URLSessionMock {

        let urlSession = URLSessionMock()

        urlSession.dataTaskImp = { (request, completionHandler) in

            self.requestedURL = request.url

            let dataTask = URLSessionDataTaskMock()

            dataTask.resumeImp = {

                completionHandler(self.responseData, HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
            }

            return dataTask
        }

        return urlSession
    }

    func urlSession(_ urlSession: URLSessionMock, returnsResponse responseData: Data) {

        self.responseData = responseData
    }

    func searchService(_ urlSession: URLSessionMock) -> ImageSearchServiceImp {

        ImageSearchServiceImp(urlSession: urlSession)
    }

    func expectedResults() -> ImageSearchResults {

        ImageSearchResults(images_results: [
            ImageSearchResult(original: "https://www.apple.com/ac/structured-data/images/open_graph_logo.png?202005131207"),
            ImageSearchResult(original: "https://as-images.apple.com/is/og-default?wid=1200&hei=630&fmt=jpeg&qlt=95&op_usm=0.5,0.5&.v=1525370171638"),
            ImageSearchResult(original: "https://yt3.ggpht.com/a/AATXAJxK3dHVZIVCtxjYZ7mp77wBbCs9fw4zU46V_Q=s900-c-k-c0xffffffff-no-rj-mo"),
            ImageSearchResult(original: "https://pbs.twimg.com/profile_images/1110319067280269312/iEqpsbUA_400x400.png"),
            ImageSearchResult(original: "https://www.apple.com/ac/structured-data/images/knowledge_graph_logo.png?201809210816")
        ])
    }

    func perform(_ searchService: ImageSearchServiceImp, _ query: String) -> ImageSearchResults? {

        let result = searchService.imageSearch(query: query)
        result.sink(receiveCompletion: { error in  }, receiveValue: { result in
            self.receivedResult = result
        })

        return self.receivedResult
    }

    func searchService(_ searchService: ImageSearchServiceImp, requestedURL url: URL) {

        XCTAssertTrue(requestedURL?.isSameAs(url) ?? false, "Request URL is not correct")
    }

    func results(_ results: ImageSearchResults?, areEqualTo expectedResults: ImageSearchResults) {

        XCTAssertEqual(results, expectedResults, "Results are not the expected results")
    }
}
