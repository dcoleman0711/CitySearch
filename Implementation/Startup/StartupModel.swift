//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation
import Combine

protocol StartupModel {

    func observeAppTitleText(_ update: @escaping ValueUpdate<String>)

    func startTransitionTimer()
}

class StartupModelImp: StartupModel {

    private let appTitleText: String
    private let timerType: Timer.Type
    private let transitionCommand: StartupTransitionCommand
    private let initialResults: CitySearchService.SearchFuture

    private var test: AnyCancellable!

    init(timerType: Timer.Type, transitionCommand: StartupTransitionCommand, searchService: CitySearchService) {

        self.appTitleText = "City Search"
        self.timerType = timerType

        self.transitionCommand = transitionCommand

        initialResults = searchService.citySearch()
    }

    func observeAppTitleText(_ update: @escaping ValueUpdate<String>) {

        update(appTitleText)
    }

    func startTransitionTimer() {

        // Using TimerPublisher is a more "pure" reactive approach, but by going indirectly through scheduledTimer, it's easier to mock it in unit tests to allow me to fire the timer manually.  Mocking TimerPublisher is not easy because it's a final class and Publisher involves multiple associatedtypes
        let subject = PassthroughSubject<Date, Error>()
        self.timerType.scheduledTimer(withTimeInterval: 4.0, repeats: false, block: { timer in subject.send(Date()) })

        let beginTransitionEvents = initialResults.zip(subject).map( { initialResults, fireDate in  initialResults })

        var subscriber: Cancellable?
        subscriber = beginTransitionEvents.sink(receiveCompletion: { error in }, receiveValue: { initialResults in

            self.fireTransitionTimer(initialResults: CitySearchResults.emptyResults())
            subscriber = nil
        })
    }

    private func fireTransitionTimer(initialResults: CitySearchResults) {

        transitionCommand.invoke()
    }
}