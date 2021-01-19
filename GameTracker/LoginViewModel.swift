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
import KeychainAccess
import Amplify

class LoginViewModel: ObservableObject, Identifiable {
    
    @Published
    var loginModel: LoginModel = LoginModel()
    
    @Published
    var successfulLogin: Bool = false
    
    private var gameTrackerFetcher: GameTrackerFetcher? = nil
    private var steamFetcher: SteamFetchable? = nil
    private var disposables = Set<AnyCancellable>()
    private let keychain = Keychain(service: "com.michaelslattery.GameTracker")
    
    lazy var handler: SteamLoginVCHandler = { [weak self] user, error in
        if let self = self, let user = user, let steamId = user.steamID64 {
            self.save(steamId: steamId)
            self.getPlayerSummary(steamId: steamId)
        } else {
            print("ERROR: \(error)")
        }
    }
    
    init(steamFetcher: SteamFetchable) {
        self.steamFetcher = steamFetcher
    }
    
    init(gameTrackerFetcher: GameTrackerFetcher) {
        self.gameTrackerFetcher = gameTrackerFetcher
    }
    
    func signIn() {
        Amplify.Auth.signIn(username: loginModel.username, password: loginModel.password)
            .resultPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                if case let .failure(authError) = $0 {
                    print("Sign in failed \(authError)")
                }
            }
            receiveValue: { [weak self] value in
                guard let self = self else { return }
                print("Sign in succeeded")
                User.shared.updateUserInfo(username: self.loginModel.username, firstName: "", lastName: "")
                self.successfulLogin = true
            }
            .store(in: &disposables)
    }
    
    private func getPlayerSummary(steamId: String) {
        guard let steamFetcher = steamFetcher else { return }
        
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
    
    private func save(steamId: String) {
        keychain["steamId"] = steamId
    }
}
