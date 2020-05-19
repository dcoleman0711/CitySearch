//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol AsyncImageViewModelFactory {

    func viewModel(model: AsyncImageModel) -> AsyncImageViewModel
}

class AsyncImageViewModelFactoryImp : AsyncImageViewModelFactory {

    func viewModel(model: AsyncImageModel) -> AsyncImageViewModel {

        fatalError("Implement")
    }
}