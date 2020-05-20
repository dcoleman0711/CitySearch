//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

typealias ValueUpdate<T> = (_ value: T) -> Void

func mapUpdate<In, Out>(_ out: @escaping ValueUpdate<Out>, _ mapFunction: @escaping (In) -> Out) -> ValueUpdate<In> {

    { inValue in out(mapFunction(inValue)) }
}

func zipUpdate<T1, T2>(_ out: @escaping ValueUpdate<(T1, T2)>) -> (ValueUpdate<T1>, ValueUpdate<T2>) {

    var lastT1: T1?
    var lastT2: T2?

    let zipIfReady = {

        guard let t1 = lastT1, let t2 = lastT2 else { return }

        out((t1, t2))
    }

    let observer1 = { (t1: T1) in

        lastT1 = t1
        zipIfReady()
    }

    let observer2 = { (t2: T2) in

        lastT2 = t2
        zipIfReady()
    }

    return (observer1, observer2)
}