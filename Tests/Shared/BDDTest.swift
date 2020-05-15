//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

protocol Steps {

    init()
}

class BDDTest<StepsType: Steps>: XCTestCase {

    var steps: StepsType!

    var given: StepsType { steps }
    var when: StepsType { steps }
    var then: StepsType { steps }

    override func setUp() {

        super.setUp()

        steps = StepsType()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }
}
