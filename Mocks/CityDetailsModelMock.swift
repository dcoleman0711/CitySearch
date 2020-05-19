//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class CityDetailsModelMock : CityDetailsModel {

    public var observeTitleTextImp: (_ update: @escaping ValueUpdate<String>) -> Void = { update in }
    func observeTitleText(_ update: @escaping ValueUpdate<String>) {

        observeTitleTextImp(update)
    }
}
