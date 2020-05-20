//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation
import Combine

class ImageSearchServiceMock: ImageSearchService {

    var imageSearchImp: (_ query: String) -> ImageSearchPublisher = { query in Future<ImageSearchResults, Error> { promise in promise(.success(ImageSearchResultsStub.stubResults())) }.eraseToAnyPublisher() }
    func imageSearch(query: String) -> ImageSearchPublisher {

        imageSearchImp(query)
    }
}
