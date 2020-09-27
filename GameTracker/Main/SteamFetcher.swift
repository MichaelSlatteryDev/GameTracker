//
//  SteamFetcher.swift
//  GameTracker
//
//  Created by mac on 9/13/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation
import Combine

protocol SteamFetchable {
    func getOwnedGames() -> AnyPublisher<GetOwnedGamesResponse, SteamError>
}

class SteamFetcher {
    private let session: URLSession
    
    struct SteamWebAPI {
        static let scheme = "https"
        static let host = "api.steampowered.com"
        static let path = "/IPlayerService"
        // Your Steam Key
        static let key = ""
        // Your Steam Id
        static let steamId = ""
    }
    
    init(session: URLSession = .shared) {
      self.session = session
    }
    
    func makeGetOwnedGamesComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = SteamWebAPI.scheme
        components.host = SteamWebAPI.host
        components.path = SteamWebAPI.path + "/GetOwnedGames/v1/"
        
        components.queryItems = [
            URLQueryItem(name: "key", value: SteamWebAPI.key),
            URLQueryItem(name: "steamid", value: SteamWebAPI.steamId),
            URLQueryItem(name: "include_appinfo", value: "1"),
            URLQueryItem(name: "include_played_free_games", value: "1")
        ]
        
        return components
    }
    
    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, SteamError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                .parsing(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension SteamFetcher: SteamFetchable {
    func getOwnedGames() -> AnyPublisher<GetOwnedGamesResponse, SteamError> {
        return fetchData(with: makeGetOwnedGamesComponents())
    }
    
    private func fetchData<T>(with components: URLComponents) -> AnyPublisher<T, SteamError> where T: Decodable {
        guard let url = components.url else {
            let error = SteamError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                .network(description: error.localizedDescription)
            }.flatMap { pair in
                self.decode(pair.data)
            }
            .eraseToAnyPublisher()
    }
}
