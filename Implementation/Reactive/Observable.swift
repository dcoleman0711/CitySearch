//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class Observable<T> {

    private var value: T

    init(_ value: T) {

        self.value = value
    }

    func subscribe(_ listener: ValueUpdate<T>, updateImmediately: Bool = false) {

        listener(self.value)
    }
}