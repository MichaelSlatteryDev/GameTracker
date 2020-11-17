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
    func getPlayerSummary(steamId: String) -> AnyPublisher<GetPlayerSummariesResponse, SteamError>
    func getPlayerAchievments(gameId: String) -> AnyPublisher<GetPlayerAchievementsResponse, SteamError>
}

enum Endpoints {
    
    case getOwnedGames
    case getRecentlyPlayedGames
    case getPlayerSummary
    case getPlayerAchievements
    case getUserStatsForGame
    
    func path() -> String {
        switch (self) {
        case .getOwnedGames: return "/IPlayerService/GetOwnedGames/v1/"
        case .getRecentlyPlayedGames: return "/IPlayerService/GetRecentlyPlayedGames/v1/"
        case .getPlayerSummary: return "/ISteamUser/GetPlayerSummaries/v2/"
        case .getPlayerAchievements: return "/ISteamUserStats/GetPlayerAchievements/v0001/"
        case .getUserStatsForGame: return "/ISteamUserStats/GetUserStatsForGame/v0002/"
        }
    }
}

class SteamFetcher {
    private let session: URLSession
    
    private var key: String = {
        do {
            let data = try String(contentsOfFile: "/Users/michaelslattery/Desktop/SteamInfo.txt", encoding: .utf8)
            let myStrings = data.components(separatedBy: .newlines)
            return myStrings[0]
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
        var components = makeBaseURLComponents(path: Endpoints.getOwnedGames.path())
        
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "steamid", value: User.shared.steamId),
            URLQueryItem(name: "include_appinfo", value: "1"),
            URLQueryItem(name: "include_played_free_games", value: "1")
        ])
        
        return components
    }
    
    func makeGetRecentlyPlayedGamesComponents() -> URLComponents {
        var components = makeBaseURLComponents(path: Endpoints.getRecentlyPlayedGames.path())
        
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "steamid", value: User.shared.steamId),
            URLQueryItem(name: "count", value: "3")
        ])
        
        return components
    }
    
    func makeGetPlayerSummaryCompnents(steamId: String) -> URLComponents {
        var components = makeBaseURLComponents(path: Endpoints.getPlayerSummary.path())
        
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "steamids", value: "\([steamId])")
        ])
        
        return components
    }
    
    func makeGetPlayerAchievements(gameId: String) -> URLComponents {
        var components = makeBaseURLComponents(path: Endpoints.getPlayerAchievements.path())
        
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "steamid", value: User.shared.steamId),
            URLQueryItem(name: "appid", value: gameId)
        ])
        
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
        
        print(String(data: data, encoding: .utf8))

        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                .parsing(description: "\(error)")
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
    
    func getPlayerSummary(steamId: String) -> AnyPublisher<GetPlayerSummariesResponse, SteamError> {
        return fetchData(with: makeGetPlayerSummaryCompnents(steamId: steamId))
    }
    
    func getPlayerAchievments(gameId: String) -> AnyPublisher<GetPlayerAchievementsResponse, SteamError> {
        return fetchData(with: makeGetPlayerAchievements(gameId: gameId))
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
