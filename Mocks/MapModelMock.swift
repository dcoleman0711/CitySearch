//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation
import CoreLocation

class MapModelMock: MapModel {

    var observeGeoCoordinatesImp: (_ observer: @escaping ValueUpdate<CLLocationCoordinate2D>) -> Void = { observer in }
    func observeGeoCoordinates(_ observer: @escaping ValueUpdate<CLLocationCoordinate2D>) {

        observeGeoCoordinatesImp(observer)
    }
}
