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
    func getRecentlyPlayedGames() -> AnyPublisher<GetRecentlyPlayedGamesResponse, SteamError>
}

class SteamFetcher {
    private let session: URLSession
    
    private lazy var key: String = {
        do {
            let data = try String(contentsOfFile: "/Users/michaelslattery/Desktop/SteamInfo.txt", encoding: .utf8)
            let myStrings = data.components(separatedBy: .newlines)
            return myStrings[0]
        } catch {
            print(error)
        }
        return ""
    }()
    
    private lazy var steamId: String = {
        do {
            let data = try String(contentsOfFile: "/Users/michaelslattery/Desktop/SteamInfo.txt", encoding: .utf8)
            let myStrings = data.components(separatedBy: .newlines)
            return myStrings[1]
        } catch {
            print(error)
        }
        return ""
    }()
    
    struct SteamWebAPI {
        static let scheme = "https"
        static let host = "api.steampowered.com"
    }
    
    init(session: URLSession = .shared) {
      self.session = session
    }
    
    func makeGetOwnedGamesComponents() -> URLComponents {
        var components = makeBaseURLComponents(path: "/IPlayerService/GetOwnedGames/v1/")
        
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "steamid", value: steamId),
            URLQueryItem(name: "include_appinfo", value: "1"),
            URLQueryItem(name: "include_played_free_games", value: "1")
        ])
        
        return components
    }
    
    func makeGetRecentlyPlayedGamesComponents() -> URLComponents {
        var components = makeBaseURLComponents(path: "/IPlayerService/GetRecentlyPlayedGames/v1/")
        
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "steamid", value: steamId),
            URLQueryItem(name: "count", value: "3")
        ])
        
        return components
    }
    
    func makeGetPlayerSummariesCompnents() -> URLComponents {
        var components = makeBaseURLComponents(path: "/ISteamUser/GetPlayerSummaries/v2/")
        
//        components.queryItems?.append(contentsOf: [
//            URLQueryItem
//        ])
        
        return components
    }
    
    private func makeBaseURLComponents(path: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = SteamWebAPI.scheme
        components.host = SteamWebAPI.host
        components.path = path
        
        components.queryItems = [
            URLQueryItem(name: "key", value: key)
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
    
    func getRecentlyPlayedGames() -> AnyPublisher<GetRecentlyPlayedGamesResponse, SteamError> {
        return fetchData(with: makeGetRecentlyPlayedGamesComponents())
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
