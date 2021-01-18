//
//  MainViewModel.swift
//  GameTracker
//
//  Created by Michael Slattery on 8/23/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI
import Combine

class MainViewModel: ObservableObject, Identifiable {
    
    @Published
    private(set) var mainModel: MainModel = MainModel()
    
    @Published
    var recentGames: [MainModel.GameCell] = []
    
    // Make var becuase can be nil depending on init used
    private var gameTrackerFetcher: GameTrackerFetcher? = nil
    private var steamFetcher: SteamFetchable? = nil
    private var disposables = Set<AnyCancellable>()
    
    // Steam Init
    init(steamFetcher: SteamFetchable, scheduler: DispatchQueue = DispatchQueue(label: "MainViewModel")) {
        self.steamFetcher = steamFetcher
        
        fetchRecentGames()
    }
    
    // IGDB Init
    init(gameTrackerFetcher: GameTrackerFetcher, scheduler: DispatchQueue = DispatchQueue(label: "MainViewModel")) {
        self.gameTrackerFetcher = gameTrackerFetcher
    }
    
    func mostRecent() -> Array<MainModel.GameCell> {
        return recentGames
    }
    
    func fetchRecentGames() {
        guard let steamFetcher = steamFetcher else { return }
        
        steamFetcher.getRecentlyPlayedGames()
            .map { response in
                response.response.games.map {
                    MainModel.GameCell.init(id: $0.appid, name: $0.name,
                                            hoursPlayed: $0.playtimeForever.toHoursAndMinutes(),
                                            background: "https://steamcdn-a.akamaihd.net/steam/apps/\($0.appid)/library_hero.jpg")
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                  self.recentGames = []
                case .finished:
                  break
                }
            }, receiveValue: { [weak self] forecast in
                guard let self = self else { return }
                self.recentGames = forecast
                self.fetchAchievments(games: forecast)
            })
            .store(in: &disposables)
    }
    
    func fetchAchievments(games: [MainModel.GameCell]) {
        guard let steamFetcher = steamFetcher else { return }
        
        for game in games {
            steamFetcher.getPlayerAchievments(gameId: String(game.id))
                .map { response in
                    if let index = self.recentGames.firstIndex(where: {$0.name == response.playerstats.gameName}) {
                        DispatchQueue.main.async {
                            self.recentGames[index].totalAchievements = response.playerstats.achievements.count
                            self.recentGames[index].completedAchievements = response.playerstats.achievements.filter{$0.achieved == 1}.count
                        }
                    }
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { value in
                    switch value {
                    case .failure:
                        print("Game has no achievements")
                    case .finished:
                      break
                    }
                }, receiveValue: { forecast in
                    print("Success")
                })
                .store(in: &disposables)
        }
    }
}
