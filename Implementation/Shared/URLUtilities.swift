//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class URLRequestBuilder {

    static func buildHTTPSRequest(host: String, path: String = "", headers: [String: String] = [:], queryParameters: [String: String] = [:]) throws -> URLRequest {

        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryParameters.map { key, value in URLQueryItem(name: key, value: value) }

        guard let url = components.url else {
            throw URLError(.badURL) as Error
        }

        var request = URLRequest(url: url)

        for (key, value) in headers {

            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}

extension URL {

    func isSameAs(_ other: URL) -> Bool {

        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let otherComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return false
        }

        return components.scheme == otherComponents.scheme &&
                components.host == otherComponents.host &&
                components.path == otherComponents.path &&
                Set<URLQueryItem>(components.queryItems ?? []) == Set<URLQueryItem>(otherComponents.queryItems ?? [])
    }
}