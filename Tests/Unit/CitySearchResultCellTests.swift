//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class CitySearchResultCellTests: XCTestCase {

    var steps: CitySearchResultCellSteps!

    var given: CitySearchResultCellSteps { steps }
    var when: CitySearchResultCellSteps { steps }
    var then: CitySearchResultCellSteps { steps }

    override func setUp() {

        super.setUp()

        steps = CitySearchResultCellSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testTitleLabel() {

        let titleData = given.titleData()
        let viewModel = given.viewModel(titleData)
        let titleLabel = given.titleLabel()
        let binder = given.binder()
        let searchResultCell = given.searchResultCellIsCreated(titleLabel: titleLabel, binder: binder)

        when.assignViewModel(viewModel, toCell: searchResultCell)

        then.titleLabel(titleLabel, dataIs: titleData)
    }
}

class CitySearchResultCellSteps {

    var labelBindings: [UILabel: LabelViewModel] = [:]

    func binder() -> ViewBinderMock {

        let binder = ViewBinderMock()

        binder.bindLabelTextImp = { (label) in

            { (viewModel) in

                self.labelBindings[label] = viewModel
            }
        }

        return binder
    }

    func titleData() -> LabelViewModel {

        LabelViewModel(text: "Test Title", font: UIFont())
    }

    func titleLabel() -> UILabel {

        UILabel()
    }

    func viewModel(_ titleData: LabelViewModel) -> CitySearchResultViewModelMock {

        let viewModel = CitySearchResultViewModelMock()

        viewModel.titleData = titleData

        return viewModel
    }

    func searchResultCellIsCreated(titleLabel: UILabel, binder: ViewBinderMock) -> CitySearchResultCell {

        CitySearchResultCell(titleLabel: titleLabel, binder: binder)
    }

    func assignViewModel(_ viewModel: CitySearchResultViewModelMock, toCell cell: CitySearchResultCell) {

        cell.viewModel = viewModel
    }

    func titleLabel(_ label: UILabel, dataIs expectedData: LabelViewModel) {

        XCTAssertEqual(labelBindings[label], expectedData, "Title label text is not correct")
    }
}