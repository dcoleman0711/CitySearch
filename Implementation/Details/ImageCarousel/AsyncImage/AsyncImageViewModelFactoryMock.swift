//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class AsyncImageViewModelFactoryMock : AsyncImageViewModelFactory {

    var viewModelImp: ( _ model: AsyncImageModel) -> AsyncImageViewModel = { model in AsyncImageViewModelMock() }
    func viewModel(model: AsyncImageModel) -> AsyncImageViewModel {

        viewModelImp(model)
    }
}
