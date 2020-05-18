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
        let cellData = given.cellData(viewModels)

        when.updateViewModels(cellUpdate, cellData)

        then.collectionView(collectionView, cellsHaveViewModels: viewModels)
    }

    func testBindCollectionViewSizes() {

        let collectionView = given.collectionView()
        let binder = given.binder()
        let cellUpdate = given.bindCells(binder, collectionView)
        let viewModels = given.viewModels()
        let cellData = given.cellData(viewModels)
        let cellSizes = given.cellSizes(cellData)

        when.updateViewModels(cellUpdate, cellData)

        then.collectionView(collectionView, cellsHaveSizes: cellSizes)
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

    func bindCells(_ binder: CollectionViewBinderImp<String, TestMVVMCell>, _ collectionView: UICollectionViewMock) -> ValueUpdate<[CellData<String>]> {

        binder.bindCells(collectionView: collectionView)
    }

    func viewModels() -> [String] {

        (0..<5).map( { "StubViewModel #\($0)" })
    }

    func cellData(_ viewModels: [String]) -> [CellData<String>] {

        viewModels.enumerated().map { (index, viewModel) in CellData<String>(viewModel: viewModel, size: CGSize(width: CGFloat(index) * 32.0, height: CGFloat(index) * 64.0), tapCommand: CellTapCommandMock()) }
    }

    func cellSizes(_ cellData: [CellData<String>]) -> [CGSize] {

        cellData.map({$0.size})
    }

    func updateViewModels(_ cellUpdate: ValueUpdate<[CellData<String>]>, _ cellData: [CellData<String>]) {

        cellUpdate(cellData)
    }

    func collectionView(_ collectionView: UICollectionViewMock, cellsHaveViewModels expectedCellData: [String]) {

        guard let displayedCells = self.displayedCells else {
            XCTFail("Collection view is not displaying cells")
            return
        }

        let flattenedResults = [TestMVVMCell](displayedCells.joined())

        let viewModels = flattenedResults.map( { $0.viewModel } )

        XCTAssertEqual(viewModels, expectedCellData, "Collection view cells are not correct")
    }

    func collectionView(_ collectionView: UICollectionViewMock, cellsHaveSizes expectedSizes: [CGSize]) {

        guard let displayedCells = self.displayedCells else {
            XCTFail("Collection view is not displaying cells")
            return
        }

        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
            XCTFail("Collection view does not have flow layout delegate")
            return
        }

        let cellSectionIndices = (0..<displayedCells.count)
        let nestedCellIndexPaths = cellSectionIndices.map { sectionIndex -> [IndexPath] in

            let sectionCount = displayedCells[sectionIndex].count
            let rowIndices = (0..<sectionCount)

            return rowIndices.map { rowIndex in IndexPath(item: rowIndex, section: sectionIndex) }
        }

        let cellIndexPaths = [IndexPath](nestedCellIndexPaths.joined())

        let cellSizes = cellIndexPaths.map { indexPath in delegate.collectionView?(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: indexPath) ?? CGSize.zero }

        XCTAssertEqual(cellSizes, expectedSizes, "Collection view cell sizes are not correct")
    }
}

class TestMVVMCell: MVVMCollectionViewCell<String> {


}

class CellTapCommandMock: CellTapCommand {

    func invoke() {

    }
}