//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation
import CoreLocation

protocol MapModel: class {

    func observeGeoCoordinates(_ observer: @escaping ValueUpdate<CLLocationCoordinate2D>)
}

class MapModelImp: MapModel {

    private let searchResult: CitySearchResult

    init(searchResult: CitySearchResult) {

        self.searchResult = searchResult
    }

    func observeGeoCoordinates(_ observer: @escaping ValueUpdate<CLLocationCoordinate2D>) {

        observer(self.geoCoordinates())
    }

    private func geoCoordinates() -> CLLocationCoordinate2D {

        CLLocationCoordinate2D(latitude: searchResult.location.latitude, longitude: searchResult.location.longitude)
    }
}