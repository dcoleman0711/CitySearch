//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol ImageCarouselViewModel {

    func observeResults(_ observer: @escaping ValueUpdate<[CellData<AsyncImageViewModel>]>)
}

class ImageCarouselViewModelImp : ImageCarouselViewModel {

    private let model: ImageCarouselModel
    private let viewModelFactory: AsyncImageViewModelFactory

    private let viewModels = Observable<[AsyncImageViewModel]>([])
    private let cellDataArray = Observable<[CellData<AsyncImageViewModel>]>([])

    convenience init(model: ImageCarouselModel) {

        self.init(model: model, viewModelFactory: AsyncImageViewModelFactoryImp())
    }

    init(model: ImageCarouselModel, viewModelFactory: AsyncImageViewModelFactory) {

        self.model = model
        self.viewModelFactory = viewModelFactory

        setupPipeline()
    }

    private func setupPipeline() {

        // Build a pipeline from the model to the cell data array.  Whenever the model publishes new result models, this should eventually result in publishing new cell data.
        model.observeResultsModels(viewModels.map({ models in models.map(ImageCarouselViewModelImp.viewModel(self))}))
        cellDataArray.map(viewModels, { viewModels in viewModels.map( { viewModel in self.cellData(for: viewModel, image: nil) })})

        // Any time the array of view models updates, we need to subscribe to all of them for updates to their images.  On any image update event, we need to find that view model in the view model array and, if it is still present, refresh the cell data (to update the size) and set the cell data value with the refreshed item
        // Make sure to capture self weakly, to avoid retain cycles that could keep removed view models and their subscriptions alive
        viewModels.subscribe({ [weak self] in

            self?.observeResultViewModels($0)

        }, updateImmediately: true)
    }

    func observeResults(_ observer: @escaping ValueUpdate<[CellData<AsyncImageViewModel>]>) {

        cellDataArray.subscribe(observer, updateImmediately: true)
    }

    private func viewModel(for model: AsyncImageModel) -> AsyncImageViewModel {

        viewModelFactory.viewModel(model: model)
    }

    private func cellData(for viewModel: AsyncImageViewModel, image: UIImage? = nil) -> CellData<AsyncImageViewModel> {

        let cellSize = self.cellSize(for: image)
        return CellData<AsyncImageViewModel>(viewModel: viewModel, size: cellSize, tapCommand: nil)
    }

    private func observeResultViewModels(_ viewModels: [AsyncImageViewModel]) {

        for viewModel in viewModels {
            observeResultViewModel(viewModel)
        }
    }

    private func observeResultViewModel(_ viewModel: AsyncImageViewModel) {

        viewModel.observeImage { image in
            self.refresh(viewModel: viewModel, image: image)
        }
    }

    private func refresh(viewModel: AsyncImageViewModel, image: UIImage?) {

        guard let index = self.cellDataArray.value.firstIndex(where: { data in data.viewModel === viewModel }) else {
            return
        }

        var cellDataArray = self.cellDataArray.value
        cellDataArray[index] = self.cellData(for: viewModel, image: image)
        self.cellDataArray.value = cellDataArray
    }

    private func cellSize(for image: UIImage?) -> CGSize {

        let cellHeight: CGFloat = 256.0
        let aspectRatio = image.map { image in image.size.width / image.size.height } ?? 1.0

        return CGSize(width: cellHeight * aspectRatio, height: cellHeight)
    }
}