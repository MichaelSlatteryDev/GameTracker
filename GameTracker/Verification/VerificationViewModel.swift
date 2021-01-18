//
//  VerificationViewModel.swift
//  GameTracker
//
//  Created by Michael Slattery on 1/18/21.
//  Copyright © 2021 Michael Slattery. All rights reserved.
//

import SwiftUI
import Combine

class VerificationViewModel: ObservableObject, Identifiable {
    
    @Published
    private(set) var verificationModel: VerificationModel = VerificationModel()
    
    @Published var code: VerificationModel.Code
    
    private let gameTrackerFetcher: GameTrackerFetcher
    private var disposables = Set<AnyCancellable>()
    
    init(gameTrackerFetcher: GameTrackerFetcher) {
        self.gameTrackerFetcher = gameTrackerFetcher
        self.code = VerificationModel.Code(firstDigit: "1",
                                           secondDigit: "2",
                                           thirdDigit: "3",
                                           fourthDigit: "4",
                                           fifthDigit: "5",
                                           sixthDigit: "6")
    }
    
    func verifySignUp() {
        
    }
}
