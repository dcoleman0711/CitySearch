//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class OpenDetailsCommandMock: OpenDetailsCommand {

    var invokeImp: () -> Void = { }
    func invoke() {

        invokeImp()
    }
}
