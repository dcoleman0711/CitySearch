//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol AsyncImageViewModel: class {

    func observeImage(_ observer: @escaping ValueUpdate<UIImage?>)
}

class AsyncImageViewModelImp: AsyncImageViewModel {

    private let model: AsyncImageModel

    private let image = Observable<UIImage?>(nil)

    init(model: AsyncImageModel) {

        self.model = model

        model.observeImage(image.map({$0}))
    }

    func observeImage(_ observer: @escaping ValueUpdate<UIImage?>) {

        image.subscribe(observer, updateImmediately: true)
    }
}