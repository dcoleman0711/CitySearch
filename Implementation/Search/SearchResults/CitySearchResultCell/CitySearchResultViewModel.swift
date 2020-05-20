//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol CitySearchResultViewModel: class {

    var titleData: LabelViewModel { get }
    var tapCommand: OpenDetailsCommand { get }

    func observeIconImage(_ observer: @escaping ValueUpdate<UIImage>)
}

class CitySearchResultViewModelImp : CitySearchResultViewModel {

    private let model: CitySearchResultModel

    let titleData: LabelViewModel
    let tapCommand: OpenDetailsCommand

    init(model: CitySearchResultModel) {

        self.model = model

        self.titleData = LabelViewModel(text: model.titleText, font: UIFont.systemFont(ofSize: 12.0))
        self.tapCommand = model.tapCommand
    }

    func observeIconImage(_ observer: @escaping ValueUpdate<UIImage>) {

        observer(icon(for: model.populationClass))
    }

    private func icon(for populationClass: PopulationClass) -> UIImage {

        populationClass.accept(ImageSelector())
    }

    class ImageSelector: PopulationClassVisitor {

        typealias T = UIImage

        func visitSmall(_ class: PopulationClassSmall) -> UIImage { ImageLoader.loadImage(name: "City1")! }
        func visitMedium(_ class: PopulationClassMedium) -> UIImage { ImageLoader.loadImage(name: "City2")! }
        func visitLarge(_ class: PopulationClassLarge) -> UIImage { ImageLoader.loadImage(name: "City3")! }
        func visitVeryLarge(_ class: PopulationClassVeryLarge) -> UIImage { ImageLoader.loadImage(name: "City4")! }
    }
}
