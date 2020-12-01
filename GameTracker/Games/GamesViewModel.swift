//
//  GamesViewModel.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/21/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI
import Combine

class GamesViewModel: ObservableObject, Identifiable {
    
    @Published
    var allGames: [MainModel.GameCell] = []
    
    private let steamFetcher: SteamFetchable
    private let igdbFetcher: IGDBFetchable
    private var disposables = Set<AnyCancellable>()
    private let gamesInRow = 3
    private var accessToken = ""
    let dispatchGroup = DispatchGroup()
    
    init(steamFetcher: SteamFetchable, igdbFetcher: IGDBFetchable, scheduler: DispatchQueue = DispatchQueue(label: "GamesViewModel")) {
        self.steamFetcher = steamFetcher
        self.igdbFetcher = igdbFetcher
        
        getTwitchToken()
    }
    
    func fetchAllGames() {
        steamFetcher.getOwnedGames()
            .map { response in
                response.response.games.map {
                    MainModel.GameCell.init(id: $0.appid, name: $0.name,
                                            hoursPlayed: $0.playtimeForever.toHoursAndMinutes(),
                                            background: "https://steamcdn-a.akamaihd.net/steam/apps/\($0.appid)/library_600x900.jpg")
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                  self.allGames = []
                case .finished:
                  break
                }
            }, receiveValue: { [weak self] forecast in
                guard let self = self else { return }
                let sortedGame = forecast.sorted { $0.name.lowercased() < $1.name.lowercased() }
                self.allGames = Array(sortedGame)
            })
            .store(in: &disposables)
    }
    
    func getTwitchToken() {
        igdbFetcher.getTwitchToken()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.accessToken = ""
                case .finished:
                  break
                }
            }, receiveValue: { [weak self] forecast in
                guard let self = self else { return }
                self.accessToken = forecast.accessToken
            })
            .store(in: &disposables)
    }
    
    func getIGDBGames(name: String, completion: @escaping (Bool) -> ()) {
        DispatchQueue.global().async {
            self.dispatchGroup.enter()
        }
        igdbFetcher.getGames(accessToken: accessToken, name: name)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .failure:
                    print(value)
                    completion(false)
                case .finished:
                    DispatchQueue.global().async{
                        self.dispatchGroup.leave()
                    }
                    break
                }
            }, receiveValue: { [weak self] forecast in
                guard let self = self, let game = forecast.first else { return }
                if let index = self.allGames.firstIndex(where: { $0.name == game.name }) {
                    self.getGameCover(gameId: game.id, cellIndex: index, completion: completion)
                } else {
                    completion(false)
                }
            })
            .store(in: &disposables)
    }
    
    func getGameCover(gameId: Int, cellIndex: Int, completion: @escaping  (Bool) -> ()) {
        DispatchQueue.global().async {
            self.dispatchGroup.enter()
        }
        igdbFetcher.getGameCover(accessToken: accessToken, gameId: gameId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .failure:
                    print(value)
                    completion(false)
                case .finished:
                    DispatchQueue.global().async {
                        self.dispatchGroup.leave()
                    }
                    break
                }
            }, receiveValue: { [weak self] forecast in
                guard let self = self, let cover = forecast.first else {
                    completion(false)
                    return
                }
                var updatedCell = self.allGames[cellIndex]
                updatedCell.igdbId = cover.game
                updatedCell.background = "https://images.igdb.com/igdb/image/upload/t_cover_big/\(cover.imageId).jpg"
                self.allGames[cellIndex] = updatedCell
                completion(true)
            })
            .store(in: &disposables)
    }
}
