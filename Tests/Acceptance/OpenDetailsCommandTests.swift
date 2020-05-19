//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class OpenDetailsCommandTests: XCTestCase {

    var steps: OpenDetailsCommandSteps!

    var given: OpenDetailsCommandSteps { steps }
    var when: OpenDetailsCommandSteps { steps }
    var then: OpenDetailsCommandSteps { steps }

    override func setUp() {

        super.setUp()

        steps = OpenDetailsCommandSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testOpenDetailsCommand() {

        let searchResult = given.searchResult()
        let searchScreen = given.searchScreen()
        let navigationStack = given.navigationStack(for: searchScreen)
        let openDetailsCommand = given.openDetailsCommand(for: searchResult, searchScreen: searchScreen)
        let detailsScreen = given.detailsScreen(for: searchResult)

        when.invoke(openDetailsCommand)

        then.detailsScreen(detailsScreen, isPushedOnto: navigationStack)
    }
}

class OpenDetailsCommandSteps {

    private let cityDetailsViewFactory = CityDetailsViewFactoryMock()

    private var pushedViewControllers: [UIViewController] = []

    func searchResult() -> CitySearchResult {

        CitySearchResultsStub.stubResults().results[0]
    }

    func searchScreen() -> SearchViewMock {

        SearchViewMock()
    }

    func navigationStack(for searchScreen: SearchViewMock) -> UINavigationControllerMock {

        let navigationStack = UINavigationControllerMock()
        navigationStack.pushViewControllerImp = { viewController, animated in

            self.pushedViewControllers.append(viewController)
        }

        searchScreen.navigationControllerMock = navigationStack

        return navigationStack
    }

    func openDetailsCommand(for searchResult: CitySearchResult, searchScreen: SearchViewMock) -> OpenDetailsCommandImp {

        let factory = OpenDetailsCommandFactoryImp(cityDetailsViewFactory: cityDetailsViewFactory)
        factory.searchView = searchScreen
        return factory.openDetailsCommand(for: searchResult) as! OpenDetailsCommandImp
    }

    func detailsScreen(for searchResult: CitySearchResult) -> CityDetailsViewMock {

        let detailsScreen = CityDetailsViewMock()

        cityDetailsViewFactory.detailsViewImp = { result in

            if result == searchResult { return detailsScreen }

            return CityDetailsViewMock()
        }

        return detailsScreen
    }

    func invoke(_ detailsCommand: OpenDetailsCommandImp) {

        detailsCommand.invoke()
    }

    func detailsScreen(_ detailsScreen: CityDetailsViewMock, isPushedOnto navigationStack: UINavigationControllerMock) {

        XCTAssertEqual(pushedViewControllers, [detailsScreen], "Details screen was not pushed onto navigation stack")
    }
}

class UINavigationControllerMock: UINavigationController {

    var pushViewControllerImp: (_ viewController: UIViewController, _ animated: Bool) -> Void = { viewController, animated in }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        pushViewControllerImp(viewController, animated)
    }
}