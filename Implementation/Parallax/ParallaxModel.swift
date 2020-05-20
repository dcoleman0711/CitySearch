//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

struct ParallaxLayer {

    public let distance: CGFloat
}

protocol ParallaxModel {

    func observeLayers(_ observer: @escaping ValueUpdate<[ParallaxLayer]>)
}

class ParallaxModelImp: ParallaxModel {

    func observeLayers(_ observer: @escaping ValueUpdate<[ParallaxLayer]>) {


    }
}
