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
    private let resultsQueue: IDispatchQueue

    private let image = Observable<UIImage?>(nil)

    convenience init(model: AsyncImageModel) {

        self.init(model: model, resultsQueue: DispatchQueue.main)
    }

    init(model: AsyncImageModel, resultsQueue: IDispatchQueue) {

        self.model = model
        self.resultsQueue = resultsQueue

        model.observeImage(image.map({$0}))
    }

    func observeImage(_ observer: @escaping ValueUpdate<UIImage?>) {

        image.subscribe({ result in self.resultsQueue.async { observer(result) } }, updateImmediately: true)
    }
}