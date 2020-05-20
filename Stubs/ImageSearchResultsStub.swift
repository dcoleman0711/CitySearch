//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class ImageSearchResultsStub {
    
    static func stubResults() -> ImageSearchResults {

        ImageSearchResults(images_results: [
            ImageSearchResult(original: "image1"),
            ImageSearchResult(original: "image2"),
            ImageSearchResult(original: "image3"),
            ImageSearchResult(original: "image4"),
            ImageSearchResult(original: "image5")
        ])
    }
}
