//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class OpenDetailsCommandFactoryMock : OpenDetailsCommandFactory {

    var openDetailsCommandImp: (_ searchResult: CitySearchResult) -> OpenDetailsCommand = { searchResult in OpenDetailsCommandMock() }
    func openDetailsCommand(for searchResult: CitySearchResult) -> OpenDetailsCommand {

        openDetailsCommandImp(searchResult)
    }
}
