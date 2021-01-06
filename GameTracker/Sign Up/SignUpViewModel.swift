//
//  SignUpViewModel.swift
//  GameTracker
//
//  Created by Michael Slattery on 1/4/21.
//  Copyright © 2021 Michael Slattery. All rights reserved.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject, Identifiable {
    
    private let gameTrackerFetcher: GameTrackerFetcher
    private var disposables = Set<AnyCancellable>()
    
    init(gameTrackerFetcher: GameTrackerFetcher) {
        self.gameTrackerFetcher = gameTrackerFetcher
    }
    
    func signUp(username: String, password: String, email: String) {
        gameTrackerFetcher.signUp(username: username, password: password, email: email)
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("An error occurred while registering a user \(authError)")
                }
            }
            receiveValue: { signUpResult in
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                } else {
                    print("SignUp Complete")
                }
            }
            .store(in: &disposables)
    }
}
