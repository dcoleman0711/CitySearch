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

            let start = 4000
            let count = 80

            let urlStr = CitySearchServiceImp.baseURL + "?skip=\(start)&limit=\(count)";
            let url = URL(string: urlStr)!

            var urlRequest = URLRequest(url: url)
            urlRequest.setValue(CitySearchServiceImp.appId, forHTTPHeaderField: CitySearchServiceImp.appIdKey)
            urlRequest.setValue(CitySearchServiceImp.appKey, forHTTPHeaderField: CitySearchServiceImp.appKeyKey)

            let task = self.urlSession.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in

                let result = self.parseResponse(data, error)
                promise(result)
            }

            task.resume();
        })
    }

    private func parseResponse(_ data: Data?, _ error: Error?) -> Result<CitySearchResults, Error> {

        guard let data = data else {

            return.failure(error ?? NSError(domain: URLError.errorDomain, code: URLError.unknown.rawValue))
        }

        do {

            let responseObj = try JSONDecoder().decode(CitySearchResults.self, from: data)
            return .success(responseObj)
        }
        catch {

            return .failure(error)
        }
    }
}
