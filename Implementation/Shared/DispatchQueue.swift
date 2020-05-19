//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol IDispatchQueue {

    func async(_ work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: IDispatchQueue {

    func async(_ work: @escaping @convention(block) () -> Void) {

        self.async(execute: work)
    }
}