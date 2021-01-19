//
//  VerificationViewModel.swift
//  GameTracker
//
//  Created by Michael Slattery on 1/18/21.
//  Copyright © 2021 Michael Slattery. All rights reserved.
//

import Combine
import Amplify

class VerificationViewModel: ObservableObject, Identifiable {
    
    @Published
    private(set) var verificationModel: VerificationModel
    
    @Published var code: VerificationModel.Code = VerificationModel.Code()
    @Published var successfulVerification: Bool = false
    
    private let gameTrackerFetcher: GameTrackerFetcher
    private var disposables = Set<AnyCancellable>()
    
    init(gameTrackerFetcher: GameTrackerFetcher, username: String) {
        self.gameTrackerFetcher = gameTrackerFetcher
        self.verificationModel = VerificationModel(username: username)
    }
    
    func verifySignUp() {
        Amplify.Auth.confirmSignUp(for: verificationModel.username, confirmationCode: code.allDigits)
        .resultPublisher
        .sink {
            if case let .failure(authError) = $0 {
                print("An error occurred while confirming sign up \(authError)")
            }
        }
        receiveValue: { [weak self] _ in
            guard let self = self else { return }
            print("Confirm signUp succeeded")
            User.shared.updateUserInfo(username: self.verificationModel.username, firstName: "", lastName: "")
            DispatchQueue.main.async {
                self.successfulVerification = true
            }
        }
        .store(in: &disposables)
    }
}
