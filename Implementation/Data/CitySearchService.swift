//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Combine

protocol CitySearchService: class {

    typealias SearchFuture = Future<CitySearchResults, Error>

    func citySearch() -> SearchFuture
}

class CitySearchServiceImp : CitySearchService {

    func citySearch() -> SearchFuture {

        let initialData = CitySearchResults(items: [
            CitySearchResult(name: "Test City 1"),
            CitySearchResult(name: "Test City 2"),
            CitySearchResult(name: "Test City 3"),
            CitySearchResult(name: "Test City 4"),
            CitySearchResult(name: "Test City 5")
        ])

        return SearchFuture({ promise in promise(.success(initialData)) })
    }
}