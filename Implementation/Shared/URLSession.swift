//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation
import Combine

extension URLSession {

    func jsonObjectPublisher<T: Decodable>(for request: URLRequest) -> AnyPublisher<T, Error> {

        dataTaskPublisher(for: request).tryMap { data, response in try JSONDecoder().decode(T.self, from: data) }.eraseToAnyPublisher()
    }
}
