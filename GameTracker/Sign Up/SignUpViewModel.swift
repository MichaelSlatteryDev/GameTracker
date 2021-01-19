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
    
    // @Published
    var signUpModel: SignUpModel
    
    @Published
    var successfulSignUp: Bool = false
    
    private let gameTrackerFetcher: GameTrackerFetcher
    private var disposables = Set<AnyCancellable>()
    
    init(gameTrackerFetcher: GameTrackerFetcher, signUpModel: SignUpModel) {
        self.gameTrackerFetcher = gameTrackerFetcher
        self.signUpModel = signUpModel
    }
    
    func signUp(username: String, password: String, email: String) {
        gameTrackerFetcher.signUp(username: username, password: password, email: email)
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("An error occurred while registering a user \(authError)")
                }
            }
            receiveValue: { [weak self] signUpResult in
                guard let self = self else { return }
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                } else {
                    print("SignUp Complete")
                }
                DispatchQueue.main.async {
                    self.successfulSignUp = true
                }
            }
            .store(in: &disposables)
    }
}
