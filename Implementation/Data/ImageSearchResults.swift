//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

struct ImageSearchResults: Codable, Equatable {

    var images_results: [ImageSearchResult]
}

struct ImageSearchResult: Codable, Equatable {

    var original: String?
}
