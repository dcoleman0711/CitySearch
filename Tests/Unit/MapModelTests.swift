//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit
import CoreLocation

class MapModelTests: XCTestCase {

    var steps: MapModelSteps!

    var given: MapModelSteps { steps }
    var when: MapModelSteps { steps }
    var then: MapModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = MapModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testGeoCoordinates() {

        let searchResult = given.searchResult()
        let geoCoordinates = given.geoCoordinates(for: searchResult)
        let model = given.modelIsCreated(searchResult: searchResult)
        let geoCoordinatesObserver = given.geoCoordinatesObserver()

        when.geoCoordinatesObserver(geoCoordinatesObserver, observesModel: model)

        then.geoCoordinatesObserver(geoCoordinatesObserver, isUpdatedTo: geoCoordinates)
    }
}

class MapModelSteps {

    private var updatedGeoCoordinates: CLLocationCoordinate2D?

    func searchResult() -> CitySearchResult {

        CitySearchResult(name: "Test City", population: 0, location: GeoPoint(latitude: 34.0, longitude: 45.0))
    }

    func geoCoordinates(for searchResult: CitySearchResult) -> CLLocationCoordinate2D {

        CLLocationCoordinate2D(latitude: searchResult.location.latitude, longitude: searchResult.location.longitude)
    }

    func geoCoordinatesObserver() -> ValueUpdate<CLLocationCoordinate2D> {

        { geoCoordinates in

            self.updatedGeoCoordinates = geoCoordinates
        }
    }


    func modelIsCreated(searchResult: CitySearchResult) -> MapModelImp {

        MapModelImp(searchResult: searchResult)
    }

    func geoCoordinatesObserver(_ geoCoordinatesObserver: @escaping ValueUpdate<CLLocationCoordinate2D>, observesModel model: MapModelImp) {

        model.observeGeoCoordinates(geoCoordinatesObserver)
    }

    func geoCoordinatesObserver(_ geoCoordinatesObserver: ValueUpdate<CLLocationCoordinate2D>, isUpdatedTo expectedGeoCoordinates: CLLocationCoordinate2D) {

        XCTAssertTrue(updatedGeoCoordinates?.latitude == expectedGeoCoordinates.latitude && updatedGeoCoordinates?.longitude == expectedGeoCoordinates.longitude, "Observer did not receive correct geo-coordinates")
    }
}