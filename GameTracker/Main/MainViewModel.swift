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
    private(set) var mainModel: MainModel = MainModel(username: "Test")
    
    @Published
    var games: [MainModel.GameCell] = []
    
    private let steamFetcher: SteamFetchable
    private var disposables = Set<AnyCancellable>()
    
    init(steamFetcher: SteamFetchable, scheduler: DispatchQueue = DispatchQueue(label: "MainViewModel")) {
        self.steamFetcher = steamFetcher
        
        fetchGames()
    }
    
    func mostRecent() -> Array<MainModel.GameCell> {
        return games
//        var games = Array<MainModel.GameCell>()
//        for index in 0...2 {
//            games.append(MainModel.GameCell(id: index))
//        }
//        return games
    }
    
    func fetchGames() {
        steamFetcher.getOwnedGames()
            .map { response in
                response.response.games.map {
                    MainModel.GameCell.init(id: $0.appid, name: $0.name, hoursPlayed: "\($0.playtimeForever)")
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                  self.games = []
                case .finished:
                  break
                }
            }, receiveValue: { [weak self] forecast in
                guard let self = self else { return }
                self.games = forecast
            })
            .store(in: &disposables)
    }
}
