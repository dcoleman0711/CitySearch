//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class CitySearchResultModelMock : CitySearchResultModel {

    var titleText: String = ""
    var populationClass: PopulationClass = PopulationClassSmall()

    var tapCommand: OpenDetailsCommand = OpenDetailsCommandMock()
}
