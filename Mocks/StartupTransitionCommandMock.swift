//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class StartupTransitionCommandMock: StartupTransitionCommand {

    public var invokeImp: (_ initialResults: CitySearchResults) -> Void = { initialResults in }
    func invoke(initialResults: CitySearchResults) {

        invokeImp(initialResults)
    }
}
