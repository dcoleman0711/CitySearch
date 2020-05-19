//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class Observable<T> {

    var value: T {

        didSet {

            NotificationCenter.default.post(name: self.notificationName, object: nil)
        }
    }

    init(_ value: T) {

        self.value = value
    }

    func subscribe(_ listener: @escaping ValueUpdate<T>, updateImmediately: Bool = false) {

        NotificationCenter.default.addObserver(forName: self.notificationName, object: nil, queue: nil) { notification in listener(self.value) }

        if updateImmediately { listener(self.value) }
    }

    func map<T2>( _ observable: Observable<T2>, _ mapFunction: @escaping (T2) -> T) {

        observable.subscribe(map(mapFunction), updateImmediately: true)
    }

    func map<T2>( _ mapFunction: @escaping (T2) -> T) -> ValueUpdate<T2> {

        mapUpdate({ value in

            self.value = value

        }, mapFunction)
    }

    private var notificationName: Notification.Name {

        let objectId = String(UInt(bitPattern: ObjectIdentifier(self)))
        return Notification.Name(rawValue: objectId)
    }
}