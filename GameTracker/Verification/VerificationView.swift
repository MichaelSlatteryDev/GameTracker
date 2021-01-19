//
//  VerificationView.swift
//  GameTracker
//
//  Created by Michael Slattery on 1/18/21.
//  Copyright © 2021 Michael Slattery. All rights reserved.
//

import SwiftUI
import Introspect

struct VerificationView: View {
    
    @StateObject
    var verificationViewModel: VerificationViewModel
    
    var body: some View {
        BaseView {
            VStack(spacing: 20) {
                Text("We've just sent you an email. Please enter the code that was sent.")
                    .foregroundColor(.white)
                HStack {
                    BaseTextField("", text: $verificationViewModel.code.firstDigit, type: .oneTimeCode)
                    BaseTextField("", text: $verificationViewModel.code.secondDigit, type: .oneTimeCode, isActive: verificationViewModel.code.firstDigit != "")
                    BaseTextField("", text: $verificationViewModel.code.thirdDigit, type: .oneTimeCode, isActive: verificationViewModel.code.secondDigit != "")
                    BaseTextField("", text: $verificationViewModel.code.fourthDigit, type: .oneTimeCode, isActive: verificationViewModel.code.thirdDigit != "")
                    BaseTextField("", text: $verificationViewModel.code.fifthDigit, type: .oneTimeCode, isActive: verificationViewModel.code.fourthDigit != "")
                    BaseTextField("", text: $verificationViewModel.code.sixthDigit, type: .oneTimeCode, isActive: verificationViewModel.code.fifthDigit != "")
                }
                NavigationLink(
                    destination: MainView(mainViewModel: MainViewModel(steamFetcher: SteamFetcher())),
                    isActive: $verificationViewModel.successfulVerification) {
                    Button(action: {
                        verificationViewModel.verifySignUp()
                    }) {
                        Text("Submit")
                    }
                }
            }
            .padding()
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(verificationViewModel: VerificationViewModel(gameTrackerFetcher: GameTrackerFetcher(), username: ""))
    }
}
