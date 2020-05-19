//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class AsyncImageModelMock : AsyncImageModel {

    var observeImageImp: (_ observer: @escaping ValueUpdate<UIImage>) -> Void = { observer in }
    func observeImage(_ observer: @escaping ValueUpdate<UIImage>) {

        observeImageImp(observer)
    }
}
