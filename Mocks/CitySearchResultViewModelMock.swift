//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class CitySearchResultViewModelMock : CitySearchResultViewModel {

    var titleData: LabelViewModel = LabelViewModel.emptyData
    var tapCommand: OpenDetailsCommand = OpenDetailsCommandMock()
}
