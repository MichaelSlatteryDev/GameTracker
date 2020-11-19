//
//  SplashViewModel.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/19/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI
import Combine
import KeychainAccess

class SplashViewModel: ObservableObject, Identifiable {
    
    private let steamFetcher: SteamFetchable
    private var disposables = Set<AnyCancellable>()
    private let keychain = Keychain(service: "com.michaelslattery.GameTracker")
    
    @Published
    var savedCredentials: Bool
    
    @Published
    var successfulLogin: Bool = false
    
    init(steamFetcher: SteamFetchable) {
        self.steamFetcher = steamFetcher
        
        if let steamId = keychain["steamId"] {
            savedCredentials = true
            getPlayerSummary(steamId: steamId)
        } else {
           savedCredentials = false
        }
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
            }, receiveValue: { [weak self] players in
                guard let self = self, let player = players.first else { return }
                User.shared.updateUserInfo(username: player.personaname, firstName: "", lastName: "", steamId: steamId)
                self.successfulLogin = true
            })
            .store(in: &disposables)
    }
}
