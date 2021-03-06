//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

struct CitySearchResult: Codable, Equatable {

    let name: String
    let population: Int
    let location: GeoPoint
}

struct GeoPoint: Codable, Equatable {

    let latitude: Double
    let longitude: Double
}