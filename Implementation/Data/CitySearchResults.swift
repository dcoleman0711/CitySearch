//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

struct CitySearchResults: Codable, Equatable {

    static func emptyResults() -> CitySearchResults { CitySearchResults(results: []) }

    let results: [CitySearchResult]
}
