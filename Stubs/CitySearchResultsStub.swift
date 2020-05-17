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
            return CitySearchResult(name: stubName)
        }

        return CitySearchResults(items: items)
    }
}
