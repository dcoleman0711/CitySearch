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

    func testTitleLabelData() {

        let titleData = given.titleData()
        let viewModel = given.viewModel(titleData)
        let titleLabel = given.titleLabel()
        let binder = given.binder()
        let searchResultCell = given.searchResultCellIsCreated(titleLabel: titleLabel, binder: binder)

        when.assignViewModel(viewModel, toCell: searchResultCell)

        then.titleLabel(titleLabel, dataIs: titleData)
    }

    func testTitleLabelAutoResizeMaskDisabled() {

        let titleLabel = given.titleLabel()
        let searchResultCell = when.searchResultCellIsCreated(titleLabel: titleLabel)

        then.autoResizeMaskIsDisabled(for: titleLabel)
    }

    func testTitleLabelConstraints() {

        let titleLabel = given.titleLabel()
        let searchResultCell = when.searchResultCellIsCreated(titleLabel: titleLabel)

        then.titleLabel(titleLabel, isConstrainedToCenterOf: searchResultCell)
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

        LabelViewModel(text: "Test Title", font: .systemFont(ofSize: 12.0))
    }

    func titleLabel() -> UILabel {

        UILabel()
    }

    func viewModel(_ titleData: LabelViewModel) -> CitySearchResultViewModelMock {

        let viewModel = CitySearchResultViewModelMock()

        viewModel.titleData = titleData

        return viewModel
    }

    func searchResultCellIsCreated(titleLabel: UILabel, binder: ViewBinderMock = ViewBinderMock()) -> CitySearchResultCell {

        CitySearchResultCell(titleLabel: titleLabel, binder: binder)
    }

    func assignViewModel(_ viewModel: CitySearchResultViewModelMock, toCell cell: CitySearchResultCell) {

        cell.viewModel = viewModel
    }

    func titleLabel(_ label: UILabel, dataIs expectedData: LabelViewModel) {

        XCTAssertEqual(labelBindings[label], expectedData, "Title label text is not correct")
    }

    func titleLabel(_ titleLabel: UILabel, isConstrainedToCenterOf cell: CitySearchResultCell) {

        let expectedConstraints = [titleLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                                   titleLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor)]

        XCTAssertTrue(expectedConstraints.allSatisfy( { (first) in cell.constraints.contains(where: { (second) in first.isEqualToConstraint(second)}) }), "Title label is not constraint to center of cell")
    }

    func autoResizeMaskIsDisabled(for view: UIView) {

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, "Autoresize mask is not disabled")
    }
}
