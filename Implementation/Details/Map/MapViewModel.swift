//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit
import CoreLocation

protocol MapViewModel: class {

    func observeBackgroundImage(_ observer: @escaping ValueUpdate<UIImage>)
    func observeMarkerImage(_ observer: @escaping ValueUpdate<UIImage>)
    func observeMarkerFrame(_ observer: @escaping ValueUpdate<CGRect>)
}

class MapViewModelImp: MapViewModel {

    private let model: MapModel

    private let backgroundImage = ImageLoader.loadImage(name: "MapBackground.jpg")!
    private let markerImage = ImageLoader.loadImage(name: "MapMarker")!

    private let markerSize = CGSize(width: 16.0, height: 16.0)

    convenience init() {

        self.init(model: MapModelImp())
    }

    init(model: MapModel) {

        self.model = model
    }

    func observeBackgroundImage(_ observer: @escaping ValueUpdate<UIImage>) {

        observer(backgroundImage)
    }

    func observeMarkerImage(_ observer: @escaping ValueUpdate<UIImage>) {

        observer(markerImage)
    }

    func observeMarkerFrame(_ observer: @escaping ValueUpdate<CGRect>) {

        model.observeGeoCoordinates(mapUpdate(observer, MapViewModelImp.markerFrame(self)))
    }

    private func markerFrame(for geoCoordinates: CLLocationCoordinate2D) -> CGRect {

        let position = CGPoint(x: geoCoordinates.longitude / 360.0, y: (geoCoordinates.latitude + 90.0) / 180.0)
        return CGRect(origin: position, size: markerSize)
    }
}
