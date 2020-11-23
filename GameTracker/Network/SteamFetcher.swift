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
    func getOwnedGames() -> AnyPublisher<GetOwnedGamesResponse, NetworkError>
    func getRecentlyPlayedGames() -> AnyPublisher<GetRecentlyPlayedGamesResponse, NetworkError>
    func getPlayerSummary(steamId: String) -> AnyPublisher<GetPlayerSummariesResponse, NetworkError>
    func getPlayerAchievments(gameId: String) -> AnyPublisher<GetPlayerAchievementsResponse, NetworkError>
}

class SteamFetcher: Fetcher {
    
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
    
    private func makeGetOwnedGamesComponents() -> URLComponents {
        var components = makeBaseURLComponents(path: Endpoints.getOwnedGames.path())
        
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "steamid", value: User.shared.steamId),
            URLQueryItem(name: "include_appinfo", value: "1"),
            URLQueryItem(name: "include_played_free_games", value: "1")
        ])
        
        return components
    }
    
    private func makeGetRecentlyPlayedGamesComponents() -> URLComponents {
        var components = makeBaseURLComponents(path: Endpoints.getRecentlyPlayedGames.path())
        
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "steamid", value: User.shared.steamId),
            URLQueryItem(name: "count", value: "3")
        ])
        
        return components
    }
    
    private func makeGetPlayerSummaryCompnents(steamId: String) -> URLComponents {
        var components = makeBaseURLComponents(path: Endpoints.getPlayerSummary.path())
        
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "steamids", value: "\([steamId])")
        ])
        
        return components
    }
    
    private func makeGetPlayerAchievements(gameId: String) -> URLComponents {
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
}

extension SteamFetcher: SteamFetchable {
    func getOwnedGames() -> AnyPublisher<GetOwnedGamesResponse, NetworkError> {
        return fetchData(with: makeGetOwnedGamesComponents())
    }
    
    func getRecentlyPlayedGames() -> AnyPublisher<GetRecentlyPlayedGamesResponse, NetworkError> {
        return fetchData(with: makeGetRecentlyPlayedGamesComponents())
    }
    
    func getPlayerSummary(steamId: String) -> AnyPublisher<GetPlayerSummariesResponse, NetworkError> {
        return fetchData(with: makeGetPlayerSummaryCompnents(steamId: steamId))
    }
    
    func getPlayerAchievments(gameId: String) -> AnyPublisher<GetPlayerAchievementsResponse, NetworkError> {
        return fetchData(with: makeGetPlayerAchievements(gameId: gameId))
    }
}
