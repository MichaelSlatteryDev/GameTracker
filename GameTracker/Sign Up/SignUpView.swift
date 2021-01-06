//
//  SignUpView.swift
//  GameTracker
//
//  Created by Michael Slattery on 1/4/21.
//  Copyright © 2021 Michael Slattery. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject
    var signUpViewModel: SignUpViewModel
    
    @StateObject
    var signUpModel: SignUpModel
    
    @State private var isSaveDisabled: Bool = true
    
    var body: some View {
        BaseView {
            VStack {
                BaseTextField("Username", text: $signUpModel.username, type: .username)
                    .validation(signUpModel.usernameValidation)
                BaseTextField("Pasword", text: $signUpModel.password, type: .password)
                    .validation(signUpModel.passwordValidation)
                BaseTextField("Email", text: $signUpModel.email, type: .emailAddress)
                    .validation(signUpModel.emailValidation)
                Button(action: {
                    signUpViewModel.signUp(username: signUpModel.username, password: signUpModel.password, email: signUpModel.email)
                }, label: {
                    Text("Sign Up")
                })
                .disabled(isSaveDisabled)
            }
        }
        .onReceive(signUpModel.allValidation) { validation in
            isSaveDisabled = !validation.isSuccess
        }
    }
}

extension View {
    func validation(_ validationPublisher: ValidationPublisher) -> some View {
        self.modifier(ValidationModifier(validationPublisher: validationPublisher))
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(signUpViewModel: SignUpViewModel(gameTrackerFetcher: GameTrackerFetcher()), signUpModel: SignUpModel())
    }
}
