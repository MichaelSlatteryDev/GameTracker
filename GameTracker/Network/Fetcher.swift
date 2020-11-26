//
//  Fetcher.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/23/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation
import Combine

class Fetcher {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
      self.session = session
    }
    
    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, NetworkError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        print(String(data: data, encoding: .utf8))

        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                .parsing(description: "\(error)")
            }
            .eraseToAnyPublisher()
    }
    
    internal func fetchData<T>(with components: URLComponents, httpMethod: String = "GET") -> AnyPublisher<T, NetworkError> where T: Decodable {
        guard let url = components.url else {
            let error = NetworkError.url(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        return session.dataTaskPublisher(for: request)
            .mapError { error in
                .url(description: error.localizedDescription)
            }.flatMap { pair in
                self.decode(pair.data)
            }
            .eraseToAnyPublisher()
    }
    
    internal func fetchData<T>(with request: URLRequest?) -> AnyPublisher<T, NetworkError> where T: Decodable {
        guard let request = request else {
            let error = NetworkError.url(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .mapError { error in
                .url(description: error.localizedDescription)
            }.flatMap { pair in
                self.decode(pair.data)
            }
            .eraseToAnyPublisher()
    }
}
