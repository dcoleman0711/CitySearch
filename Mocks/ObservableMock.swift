//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class ObservableMock<T> : Observable<T> {

    var subscribeImp: (_ listener: @escaping ValueUpdate<T>, _ updateImmediately: Bool) -> Void = { (listener, updateImmediately) in }
    override func subscribe(_ listener: @escaping ValueUpdate<T>, updateImmediately: Bool) {

        subscribeImp(listener, updateImmediately)
    }
}
