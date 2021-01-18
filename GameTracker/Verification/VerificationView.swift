//
//  VerificationView.swift
//  GameTracker
//
//  Created by Michael Slattery on 1/18/21.
//  Copyright © 2021 Michael Slattery. All rights reserved.
//

import SwiftUI

struct VerificationView: View {
    
    @StateObject
    var verificationViewModel: VerificationViewModel
    
    var body: some View {
        BaseView {
            HStack {
                BaseTextField("", text: $verificationViewModel.code.firstDigit, type: .oneTimeCode)
                BaseTextField("", text: $verificationViewModel.code.secondDigit, type: .oneTimeCode)
                BaseTextField("", text: $verificationViewModel.code.thirdDigit, type: .oneTimeCode)
                BaseTextField("", text: $verificationViewModel.code.fourthDigit, type: .oneTimeCode)
                BaseTextField("", text: $verificationViewModel.code.fifthDigit, type: .oneTimeCode)
                BaseTextField("", text: $verificationViewModel.code.sixthDigit, type: .oneTimeCode)
            }
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(verificationViewModel: VerificationViewModel(gameTrackerFetcher: GameTrackerFetcher()))
    }
}
