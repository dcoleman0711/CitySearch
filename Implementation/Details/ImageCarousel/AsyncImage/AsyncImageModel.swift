//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol AsyncImageModel: class {

    func observeImage(_ observer: @escaping ValueUpdate<UIImage>)
}

class AsyncImageModelImp : AsyncImageModel {

    func observeImage(_ observer: @escaping ValueUpdate<UIImage>) {


    }
}