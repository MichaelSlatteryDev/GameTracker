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
    
    var allGames: [MainModel.GameCell] = []
    
    private let steamFetcher: SteamFetchable
    private var disposables = Set<AnyCancellable>()
    
    init(steamFetcher: SteamFetchable, scheduler: DispatchQueue = DispatchQueue(label: "MainViewModel")) {
        self.steamFetcher = steamFetcher
        
//        fetchAllGames()
        fetchRecentGames()
    }
    
    func mostRecent() -> Array<MainModel.GameCell> {
        return recentGames
    }
    
    func fetchAllGames() {
        steamFetcher.getOwnedGames()
            .map { response in
                response.response.games.map {
                    MainModel.GameCell.init(id: $0.appid, name: $0.name,
                                            hoursPlayed: self.minutesToHoursAndMinutes($0.playtimeForever), background: $0.imgLogoUrl)
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
                self.allGames = forecast
            })
            .store(in: &disposables)
    }
    
    func fetchRecentGames() {
        steamFetcher.getRecentlyPlayedGames()
            .map { response in
                response.response.games.map {
                    MainModel.GameCell.init(id: $0.appid, name: $0.name,
                                            hoursPlayed: self.minutesToHoursAndMinutes($0.playtimeForever),
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
            })
            .store(in: &disposables)
    }
    
    func fetchAchievments(game: MainModel.GameCell) {
        steamFetcher.getPlayerAchievments(gameId: String(game.id))
            .map { response in
                if let index = self.recentGames.firstIndex(where: {$0.name == response.playerstats.gameName}) {
                    self.recentGames[index].totalAchievements = response.playerstats.achievements.count
                    self.recentGames[index].completedAchievements = response.playerstats.achievements.map{$0.achieved == 1}.count
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
            }, receiveValue: { forecast in
                print("Success")
            })
            .store(in: &disposables)
    }
    
    private func minutesToHoursAndMinutes(_ onlyMinutes: Int) -> String {
        let hours = onlyMinutes / 60
        let minutes = onlyMinutes % 60
        return "\(hours):\(minutes)"
    }
}
