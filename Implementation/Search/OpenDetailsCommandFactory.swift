//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol OpenDetailsCommandFactory: class {

    func openDetailsCommand(for searchResult: CitySearchResult) -> OpenDetailsCommand
}

class OpenDetailsCommandFactoryImp: OpenDetailsCommandFactory {

    func openDetailsCommand(for searchResult: CitySearchResult) -> OpenDetailsCommand {

        fatalError("openDetailsCommand(for:) has not been implemented")
    }
}