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
    private var disposables = Set<AnyCancellable>()
    private var gameIndex = 0
    private let gamesInRow = 3
    
    init(steamFetcher: SteamFetchable, scheduler: DispatchQueue = DispatchQueue(label: "GamesViewModel")) {
        self.steamFetcher = steamFetcher
        
        fetchAllGames()
    }
    
    func allGamesSeperated() -> Array<MainModel.GameCell> {
        let filteredGames = allGames.enumerated().filter{ $0.offset % gamesInRow == 0 }.map{ $0.element }
        return filteredGames
    }
    
    func allGamesSubList() -> Array<MainModel.GameCell> {
        if gameIndex + gamesInRow < allGames.count {
            gameIndex += gamesInRow
            return Array(allGames[gameIndex-gamesInRow..<gameIndex])
        } else {
            return Array(allGames[gameIndex..<allGames.count])
        }
    }
    
    func fetchAllGames() {
        steamFetcher.getOwnedGames()
            .map { response in
                response.response.games.map {
                    MainModel.GameCell.init(id: $0.appid, name: $0.name,
                                            hoursPlayed: $0.playtimeForever.toHoursAndMinutes(), background: "https://steamcdn-a.akamaihd.net/steam/apps/\($0.appid)/library_600x900.jpg")
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
                self.allGames = sortedGame
            })
            .store(in: &disposables)
    }
}
