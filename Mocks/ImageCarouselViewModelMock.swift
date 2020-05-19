//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class ImageCarouselViewModelMock: ImageCarouselViewModel {

    var observeResultsViewModelsImp: (_ observer: @escaping ValueUpdate<[CellData<AsyncImageViewModel>]>) -> Void = { observer in }
    func observeResults(_ observer: @escaping ValueUpdate<[CellData<AsyncImageViewModel>]>) {

        observeResultsViewModelsImp(observer)
    }
}
