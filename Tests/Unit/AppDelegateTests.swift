//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class AppDelegateTests: XCTestCase {

    var steps: AppDelegateSteps!

    var given: AppDelegateSteps { steps }
    var when: AppDelegateSteps { steps }
    var then: AppDelegateSteps { steps }

    override func setUp() {

        super.setUp()

        steps = AppDelegateSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testPassServiceToStartupBuilder() {

        let searchService = given.searchService()
        let startupViewBuilder = given.startupViewBuilder()
        let appDelegate = given.appDelegateIsCreated(searchService, startupViewBuilder)

        when.appLaunches(appDelegate)

        then.builder(startupViewBuilder, usedSearchService: searchService)
    }
}

class AppDelegateSteps {

    private var serviceUsedToBuildStartupView: CitySearchService?

    func searchService() -> CitySearchServiceMock {

        CitySearchServiceMock()
    }

    func startupViewBuilder() -> StartupViewBuilderMock {

        let builder = StartupViewBuilderMock()

        builder.buildImp = {

            self.serviceUsedToBuildStartupView = builder.searchService

            return StartupViewImp(appTitleLabel: RollingAnimationLabelMock(), viewModel: StartupViewModelMock())
        }

        return builder
    }

    func appDelegateIsCreated(_ searchService: CitySearchServiceMock, _ startupViewBuilder: StartupViewBuilderMock) -> AppDelegate {

        AppDelegate(startupViewBuilder: startupViewBuilder, searchViewFactory: SearchViewFactoryMock(), searchService: searchService, transitionCommandFactory: StartupTransitionCommandFactoryMock())
    }

    func appLaunches(_ app: AppDelegate) {

        app.applicationDidFinishLaunching(.shared)
    }

    func builder(_ builder: StartupViewBuilderMock, usedSearchService searchService: CitySearchServiceMock) {

        XCTAssertTrue(builder.searchService === searchService, "Search service was not passed to builder")
    }
}