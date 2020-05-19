//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol CityDetailsModel {

    func observeTitleText(_ update: @escaping ValueUpdate<String>)

    func observePopulation(_ update: @escaping ValueUpdate<Int>)
}

class CityDetailsModelImp: CityDetailsModel {

    private let searchResult: CitySearchResult

    private let titleText: Observable<String>
    private let population: Observable<Int>

    convenience init(searchResult: CitySearchResult) {

        self.init(searchResult: searchResult, titleText: Observable<String>(""), population: Observable<Int>(0))
    }

    init(searchResult: CitySearchResult, titleText: Observable<String>, population: Observable<Int>) {

        self.searchResult = searchResult

        self.titleText = titleText
        self.population = population

        self.titleText.value = searchResult.name
        self.population.value = searchResult.population
    }

    func observeTitleText(_ update: @escaping ValueUpdate<String>) {

        titleText.subscribe(update, updateImmediately: true)
    }

    func observePopulation(_ update: @escaping ValueUpdate<Int>) {

        population.subscribe(update, updateImmediately: true)
    }
}