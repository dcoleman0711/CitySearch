//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class CitySearchResultsStub {

    static func stubResults() -> CitySearchResults {

        let stubItemCount = 20
        let itemIndices = [Int](0..<stubItemCount)

        let items = itemIndices.map { index -> CitySearchResult in

            let stubName = "Stub City #\(index)"
            return CitySearchResult(name: stubName, population: (index + 1) * 1000, location: GeoPoint(latitude: Double(index) * 20.0, longitude: Double(index) * 40.0))
        }

        return CitySearchResults(results: items)
    }
}
