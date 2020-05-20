//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol CityDetailsViewModel {

    func observeTitle(_ observer: @escaping ValueUpdate<LabelViewModel>)

    func observePopulationTitle(_ observer: @escaping ValueUpdate<LabelViewModel>)

    func observePopulation(_ observer: @escaping ValueUpdate<LabelViewModel>)

    func observeShowLoader(_ observer: @escaping ValueUpdate<Bool>)
}

class CityDetailsViewModelImp: CityDetailsViewModel {

    private let model: CityDetailsModel

    private let titleLabelFont = UIFont.systemFont(ofSize: 36.0)
    private let populationTitleFont = UIFont.systemFont(ofSize: 24.0)
    private let populationTitleLabelText = "Population: "

    private let numberFormatter: NumberFormatter

    init(model: CityDetailsModel) {

        self.model = model

        self.numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
    }

    func observeTitle(_ observer: @escaping ValueUpdate<LabelViewModel>) {

        model.observeTitleText(mapUpdate(observer, { titleText in LabelViewModel(text: titleText, font: self.titleLabelFont)}))
    }

    func observePopulationTitle(_ observer: @escaping ValueUpdate<LabelViewModel>) {

        observer(LabelViewModel(text: populationTitleLabelText, font: populationTitleFont))
    }

    func observePopulation(_ observer: @escaping ValueUpdate<LabelViewModel>) {

        model.observePopulation(mapUpdate(observer) { population in LabelViewModel(text: self.populationText(population), font: self.populationTitleFont) })
    }

    func observeShowLoader(_ observer: @escaping ValueUpdate<Bool>) {

        model.observeLoading(observer)
    }

    private func populationText(_ population: Int) -> String {

        numberFormatter.string(for: population) ?? ""
    }
}