//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class CollectionViewBinderTests: XCTestCase {

    var steps: CollectionViewBinderSteps!

    var given: CollectionViewBinderSteps { steps }
    var when: CollectionViewBinderSteps { steps }
    var then: CollectionViewBinderSteps { steps }

    override func setUp() {

        super.setUp()

        steps = CollectionViewBinderSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testBindCollectionViewCells() {

        let collectionView = given.collectionView()
        let binder = given.binder()
        let cellUpdate = given.bindCells(binder, collectionView)
        let viewModels = given.viewModels()

        when.updateViewModels(cellUpdate, viewModels)

        then.collectionView(collectionView, cellsHaveViewModels: viewModels)
    }
}

class CollectionViewBinderSteps {

    private var displayedCells: [[TestMVVMCell]]?

    func collectionView() -> UICollectionViewMock {

        let collectionView = UICollectionViewMock()

        CollectionViewTestUtilities.captureDisplayedData(from: collectionView, andStoreIn: &displayedCells)

        return collectionView
    }

    func binder() -> CollectionViewBinderImp<String, TestMVVMCell> {

        CollectionViewBinderImp()
    }

    func bindCells(_ binder: CollectionViewBinderImp<String, TestMVVMCell>, _ collectionView: UICollectionViewMock) -> ValueUpdate<[String]> {

        binder.bindCells(collectionView: collectionView)
    }

    func viewModels() -> [String] {

        (0..<5).map( { "StubViewModel #\($0)" })
    }

    func updateViewModels(_ cellUpdate: ValueUpdate<[String]>, _ viewModels: [String]) {

        cellUpdate(viewModels)
    }

    func collectionView(_ collectionView: UICollectionViewMock, cellsHaveViewModels expectedViewModels: [String]) {

        guard let displayedCells = self.displayedCells else {
            XCTFail("Collection view is not displaying cells")
            return
        }

        let flattenedResults = [TestMVVMCell](displayedCells.joined())

        let viewModels = flattenedResults.map( { $0.viewModel } )

        XCTAssertEqual(viewModels, expectedViewModels, "Collection view cells are not correct")
    }
}

class TestMVVMCell: MVVMCollectionViewCell<String> {


}