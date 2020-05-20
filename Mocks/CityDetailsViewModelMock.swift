//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class CityDetailsViewModelMock: CityDetailsViewModel {

    var observeTitleImp: (_ observer: @escaping ValueUpdate<LabelViewModel>) -> Void = { observer in }
    func observeTitle(_ observer: @escaping ValueUpdate<LabelViewModel>) {

        observeTitleImp(observer)
    }

    var observePopulationTitleImp: (_ observer: @escaping ValueUpdate<LabelViewModel>) -> Void = { observer in }
    func observePopulationTitle(_ observer: @escaping ValueUpdate<LabelViewModel>) {

        observePopulationTitleImp(observer)
    }

    var observePopulationImp: (_ observer: @escaping ValueUpdate<LabelViewModel>) -> Void = { observer in }
    func observePopulation(_ observer: @escaping ValueUpdate<LabelViewModel>) {

        observePopulationImp(observer)
    }

    var observeShowLoaderImp: (_ observer: @escaping ValueUpdate<Bool>) -> Void = { observer in }
    func observeShowLoader(_ observer: @escaping ValueUpdate<Bool>) {

        observeShowLoaderImp(observer)
    }
}
