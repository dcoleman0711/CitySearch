//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol StartupModel {

    func observeAppTitleText(_ update: @escaping ValueUpdate<String>)
}

class StartupModelImp: StartupModel {

    func observeAppTitleText(_ update: @escaping ValueUpdate<String>) {


    }
}