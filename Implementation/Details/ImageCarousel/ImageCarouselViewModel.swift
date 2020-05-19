//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol ImageCarouselViewModel {

    func observeResultsViewModels(_ observer: @escaping ValueUpdate<[CellData<AsyncImageViewModel>]>)
}

class ImageCarouselViewModelImp : ImageCarouselViewModel {

    func observeResultsViewModels(_ observer: @escaping ValueUpdate<[CellData<AsyncImageViewModel>]>) {


    }
}