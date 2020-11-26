//
//  IGDBFetcher.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/23/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation
import Combine

protocol IGDBFetchable {
    func getTwitchToken() -> AnyPublisher<TwitchTokenResponse, NetworkError>
    func getGames(accessToken: String, name: String) -> AnyPublisher<[GameResponse], NetworkError>
    func getGameCover(accessToken: String, gameId: Int) -> AnyPublisher<[GameCoverResponse], NetworkError>
    func getGameImageURL(imageId: String) -> URL?
}

class IGDBFetcher: Fetcher {
    
    private var clientId: String = {
        do {
            let data = try String(contentsOfFile: "/Users/michaelslattery/Desktop/SteamInfo.txt", encoding: .utf8)
            let myStrings = data.components(separatedBy: .newlines)
            return myStrings[2]
        } catch {
            print(error)
        }
        return ""
    }()
    
    private var clientSecret: String = {
        do {
            let data = try String(contentsOfFile: "/Users/michaelslattery/Desktop/SteamInfo.txt", encoding: .utf8)
            let myStrings = data.components(separatedBy: .newlines)
            return myStrings[3]
        } catch {
            print(error)
        }
        return ""
    }()
    
    struct TwitchAPI {
        static let scheme = "https"
        static let host = "id.twitch.tv"
    }
    
    struct IGDB {
        static let scheme = "https"
        static let apiHost = "api.igdb.com"
        static let imageHost = "images.igdb.com"
    }
    
    private func makeGetTwitchToken() -> URLComponents {
        var components = URLComponents()
        components.scheme = TwitchAPI.scheme
        components.host = TwitchAPI.host
        components.path = Endpoints.getTwitchToken.path()
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "grant_type", value: "client_credentials")
        ]
        
        return components
    }
    
    private func makeGetGames() -> URLComponents {
        return makeBaseURLComponents(host: IGDB.apiHost, path: Endpoints.getIGDBGames.path())
    }
    
    private func makeGetGameCover() -> URLComponents {
        return makeBaseURLComponents(host: IGDB.apiHost, path: Endpoints.getIGDBCover.path())
    }
    
    private func makeGetGameImage() -> URLComponents {
        return makeBaseURLComponents(host: IGDB.imageHost, path: Endpoints.getIGDBImage.path())
    }
    
    private func makeBaseURLComponents(host: String, path: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = IGDB.scheme
        components.host = host
        components.path = path
        
        return components
    }
    
}

extension IGDBFetcher: IGDBFetchable {
    
    func getTwitchToken() -> AnyPublisher<TwitchTokenResponse, NetworkError> {
        return fetchData(with: makeGetTwitchToken(), httpMethod: "POST")
    }
    
    func getGames(accessToken: String, name: String) -> AnyPublisher<[GameResponse], NetworkError> {
        guard let url = makeGetGames().url else {
            let error = NetworkError.url(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let request = makeURLRequest(with: url, accessToken: accessToken, query: "search \(name); fields name;")
        return fetchData(with: request)
    }
    
    func getGameCover(accessToken: String, gameId: Int) -> AnyPublisher<[GameCoverResponse], NetworkError> {
        guard let url = makeGetGameCover().url else {
            let error = NetworkError.url(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let request = makeURLRequest(with: url, accessToken: accessToken, query: "fields *; where game = \(gameId)")
        return fetchData(with: request)
    }
    
    func getGameImageURL(imageId: String) -> URL? {
        return makeGetGameImage().url?.appendingPathComponent(imageId)
    }
    
    private func makeURLRequest(with url: URL, accessToken: String, query httpBody: String = "") -> URLRequest {
        var requestHeader = URLRequest(url: url)
        requestHeader.httpBody = httpBody.data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = "POST"
        requestHeader.setValue(clientId, forHTTPHeaderField: "Client-ID")
        requestHeader.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        return requestHeader
    }
}

