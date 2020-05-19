//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class ImageCarouselModelMock : ImageCarouselModel {

    var observeResultsModelsImp: (_ observer: @escaping ValueUpdate<[AsyncImageModel]>) -> Void = { observer in }
    func observeResultsModels(_ observer: @escaping ValueUpdate<[AsyncImageModel]>) {

        observeResultsModelsImp(observer)
    }

    var setResultsImp: (_ results: [URL]) -> Void = { results in }
    func setResults(_ results: [URL]) {

        setResultsImp(results)
    }
}
