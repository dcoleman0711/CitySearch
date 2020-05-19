//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol CityDetailsModel {

    func observeTitleText(_ update: @escaping ValueUpdate<String>)
}

class CityDetailsModelImp: CityDetailsModel {

    private let searchResult: CitySearchResult

    private let titleText: Observable<String>

    convenience init(searchResult: CitySearchResult) {

        self.init(searchResult: searchResult, titleText: Observable<String>(""))
    }

    init(searchResult: CitySearchResult, titleText: Observable<String>) {

        self.searchResult = searchResult

        self.titleText = titleText

        self.titleText.value = searchResult.name
    }

    func observeTitleText(_ update: @escaping ValueUpdate<String>) {

        titleText.subscribe(update, updateImmediately: true)
    }
}