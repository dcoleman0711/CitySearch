//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation
import Combine

protocol CitySearchService: class {

    typealias SearchFuture = Future<CitySearchResults, Error>

    func citySearch() -> SearchFuture
}

class CitySearchServiceImp : CitySearchService {

    private static let appId = "ADBPbkWUGMrBs09ckVscJ6lIduElFntjprkWY3Rn"
    private static let appKey = "qxzeBZAV2pzUPlnkOJLjGainEkHCJVEdTnerWyTM"

    private static let appIdKey = "X-Parse-Application-Id"
    private static let appKeyKey = "X-Parse-REST-API-Key"

    private static let baseURL = "https://parseapi.back4app.com/classes/Continentscountriescities_City"

    private let urlSession: URLSession

    convenience init() {

        self.init(urlSession: URLSession.shared)
    }

    init(urlSession: URLSession) {

        self.urlSession = urlSession
    }

    func citySearch() -> SearchFuture {

        SearchFuture({ promise in

            let results = CitySearchResults(results: [
                CitySearchResult(name: "City 1"),
                CitySearchResult(name: "City 2"),
                CitySearchResult(name: "City 3"),
                CitySearchResult(name: "City 4"),
                CitySearchResult(name: "City 5")
            ])

            promise(.success(results))
//            let start = 0
//            let count = 10
//
//            let urlStr = CitySearchServiceImp.baseURL + "?skip=\(start)&limit=\(count)";
//            let url = URL(string: urlStr)!
//
//            var urlRequest = URLRequest(url: url)
//            urlRequest.setValue(CitySearchServiceImp.appId, forHTTPHeaderField: CitySearchServiceImp.appIdKey)
//            urlRequest.setValue(CitySearchServiceImp.appKey, forHTTPHeaderField: CitySearchServiceImp.appKeyKey)
//
//            let task = self.urlSession.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
//
//                guard let data = data else {
//
//                    promise(.failure(error ?? NSError(domain: URLError.errorDomain, code: URLError.unknown.rawValue)))
//                    return
//                }
//
//                do {
//
//                    let responseObj = try JSONDecoder().decode(CitySearchResults.self, from: data)
//                    promise(.success(responseObj))
//                }
//                catch {
//
//                    promise(.failure(error))
//                }
//            }
//
//            task.resume();
        })
    }
}