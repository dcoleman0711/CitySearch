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
}
