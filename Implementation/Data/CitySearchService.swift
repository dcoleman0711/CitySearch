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

        SearchFuture({ promise in })
    }
}