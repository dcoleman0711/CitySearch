//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class CitySearchServiceTests: XCTestCase {

    var steps: CitySearchServiceSteps!

    var given: CitySearchServiceSteps { steps }
    var when: CitySearchServiceSteps { steps }
    var then: CitySearchServiceSteps { steps }

    override func setUp() {

        super.setUp()

        steps = CitySearchServiceSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testCitySearchResponse() {

        let httpResponse = given.httpResponse()
        let urlSession = given.urlSession()
        given.urlSession(urlSession, returnsResponse: httpResponse)
        let expectedResults = given.expectedResults()
        let searchService = given.searchService(urlSession)

        let results = when.perform(searchService)

        then.results(results, areEqualTo: expectedResults)
    }
}

class CitySearchServiceSteps {

    private var receivedResult: CitySearchResults?

    func httpResponse() -> Data {

        let stubResponseFile = Bundle(for: CitySearchServiceSteps.self).url(forResource: "stubCityResponse", withExtension: "json")!
        return try! Data(contentsOf: stubResponseFile)
    }

    func urlSession() -> URLSessionMock {

        URLSessionMock()
    }

    func urlSession(_ urlSession: URLSessionMock, returnsResponse responseData: Data) {

        urlSession.dataTaskImp = { (request, completionHandler) in

            let dataTask = URLSessionDataTaskMock()

            dataTask.resumeImp = {

                completionHandler(responseData, HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
            }

            return dataTask
        }
    }

    func searchService(_ urlSession: URLSessionMock) -> CitySearchServiceImp {

        CitySearchServiceImp(urlSession: urlSession)
    }

    func expectedResults() -> CitySearchResults {

        CitySearchResults(results: [
            CitySearchResult(name: "la Massana", population: 7211),
            CitySearchResult(name: "El Tarter", population: 1052),
            CitySearchResult(name: "Arinsal", population: 1419),
            CitySearchResult(name: "les Escaldes", population: 15853),
            CitySearchResult(name: "Canillo", population: 3292),
            CitySearchResult(name: "Pas de la Casa", population: 2363),
            CitySearchResult(name: "Andorra la Vella", population: 20430),
            CitySearchResult(name: "Encamp", population: 11223),
            CitySearchResult(name: "Ordino", population: 3066),
            CitySearchResult(name: "Sant Julià de Lòria", population: 8022)
        ])
    }

    func perform(_ searchService: CitySearchServiceImp) -> CitySearchResults {

        let result = searchService.citySearch()
        result.sink(receiveCompletion: { error in  }, receiveValue: { result in
            self.receivedResult = result
        })
        return self.receivedResult!
    }

    func results(_ results: CitySearchResults, areEqualTo expectedResults: CitySearchResults) {

        XCTAssertEqual(results, expectedResults, "Results are not the expected results")
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {

    override init() {

    }

    var resumeImp: () -> Void = { }
    override func resume() {

        resumeImp()
    }
}

class URLSessionMock: URLSession {

    override init() {

    }

    var dataTaskImp: (_ request: URLRequest, _ completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask = { (request, completionHandler) in URLSessionDataTaskMock() }
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask {

        dataTaskImp(request, completionHandler)
    }
}