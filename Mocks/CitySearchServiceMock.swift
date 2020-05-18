//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Combine

class CitySearchServiceMock : CitySearchService {

    var citySearchImp: () -> SearchFuture = { SearchFuture({ promise in }) }
    func citySearch() -> SearchFuture {

        citySearchImp()
    }
}
