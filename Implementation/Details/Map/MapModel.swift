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

    func observeGeoCoordinates(_ observer: @escaping ValueUpdate<CLLocationCoordinate2D>) {


    }
}