//
//  LoginViewModel.swift
//  GameTracker
//
//  Created by Michael Slattery on 10/26/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI
import SteamLogin
import Combine

class LoginViewModel: ObservableObject, Identifiable {
    
    private let steamFetcher: SteamFetchable
    private var disposables = Set<AnyCancellable>()
    
    lazy var handler: SteamLoginVCHandler = { [weak self] user, error in
        if let user = user, let steamId = user.steamID64 {
            self?.getPlayerSummary(steamId: steamId)
        } else {
            print(error)
        }
    }
    
    init(steamFetcher: SteamFetchable) {
        self.steamFetcher = steamFetcher
    }
    
    func getPlayerSummary(steamId: String) {
        steamFetcher.getPlayerSummary(steamId: steamId)
            .map { response in
                response.response.players
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .failure:
                    print(value)
                    User.shared.cleareUserInfo()
                case .finished:
                  break
                }
            }, receiveValue: { players in
                guard let player = players.first else { return }
                User.shared.updateUserInfo(username: player.personaname, firstName: "", lastName: "", steamId: steamId)
            })
            .store(in: &disposables)
    }
}
