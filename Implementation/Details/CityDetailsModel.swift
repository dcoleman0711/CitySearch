//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation
import Combine

protocol CityDetailsModel {

    func observeTitleText(_ update: @escaping ValueUpdate<String>)

    func observePopulation(_ update: @escaping ValueUpdate<Int>)
}

class CityDetailsModelImp: CityDetailsModel {

    private let searchResult: CitySearchResult
    private let imageCarouselModel: ImageCarouselModel

    private let titleText: Observable<String>
    private let population: Observable<Int>

    convenience init(searchResult: CitySearchResult) {

        self.init(searchResult: searchResult, imageCarouselModel: ImageCarouselModelImp(), imageSearchService: ImageSearchServiceImp(), titleText: Observable<String>(""), population: Observable<Int>(0))
    }

    init(searchResult: CitySearchResult, imageCarouselModel: ImageCarouselModel, imageSearchService: ImageSearchService, titleText: Observable<String>, population: Observable<Int>) {

        self.searchResult = searchResult
        self.imageCarouselModel = imageCarouselModel

        self.titleText = titleText
        self.population = population

        self.titleText.value = searchResult.name
        self.population.value = searchResult.population

        loadImages(imageSearchService: imageSearchService)
    }

    func observeTitleText(_ update: @escaping ValueUpdate<String>) {

        titleText.subscribe(update, updateImmediately: true)
    }

    func observePopulation(_ update: @escaping ValueUpdate<Int>) {

        population.subscribe(update, updateImmediately: true)
    }

    private func loadImages(imageSearchService: ImageSearchService) {

        let imageSearch = imageSearchService.imageSearch(query: searchResult.name)
        let imageURLs = imageSearch.map { results in results.images_results.compactMap({ result in URL(string: result.original) }) }

        var publisher: AnyCancellable?
        publisher = imageURLs.sink(receiveCompletion: { completion in }, receiveValue: { imageURLs in

            self.imageCarouselModel.setResults(imageURLs)
            publisher = nil
        })
    }
}