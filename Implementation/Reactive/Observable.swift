//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class Observable<T> {

    var value: T {

        didSet {

            self.listener?(value)
        }
    }

    private var listener: ValueUpdate<T>?

    init(_ value: T) {

        self.value = value
    }

    func subscribe(_ listener: @escaping ValueUpdate<T>, updateImmediately: Bool = false) {

        self.listener = listener

        listener(self.value)
    }
}