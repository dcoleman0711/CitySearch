//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation
import Combine

protocol ImageSearchService {

    typealias ImageSearchPublisher = AnyPublisher<ImageSearchResults, Error>

    func imageSearch(query: String) -> ImageSearchPublisher
}

class ImageSearchServiceImp: ImageSearchService {

    private static let host = "serpapi.com"
    private static let path = "/search"

    private static let apiKey = "7a28f042f0a5f2a8d3444fd64a074bceee47f5837f7ee953ee255ddc5640de3b"

    private let urlSession: URLSession

    convenience init() {

        self.init(urlSession: URLSession.shared)
    }

    init(urlSession: URLSession) {

        self.urlSession = urlSession
    }

    func imageSearch(query: String) -> ImageSearchPublisher {

        do {

            let request = try buildRequest(query: query)
            return urlSession.jsonObjectPublisher(for: request).eraseToAnyPublisher()
        }
        catch
        {
            return Fail<ImageSearchResults, Error>(error: URLError(.badURL)).eraseToAnyPublisher()
        }
    }

    private func buildRequest(query: String) throws -> URLRequest {

        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            throw URLError(.badURL) as Error
        }

        let queryParameters: [String: String] = [
            "q": encodedQuery,
            "api_key": ImageSearchServiceImp.apiKey,
            "tbm": "isch",
            "ijn": "0"
        ]

        return try URLRequestBuilder.buildHTTPSRequest(host: ImageSearchServiceImp.host, path: ImageSearchServiceImp.path, queryParameters: queryParameters)
    }
}