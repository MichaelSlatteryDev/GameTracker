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
    
    @State private var isSaveDisabled: Bool = true
    
    var body: some View {
        BaseView {
            VStack {
                BaseTextField("Username", text: $signUpViewModel.signUpModel.username, type: .username)
                    .validation(signUpViewModel.signUpModel.usernameValidation)
                BaseTextField("Pasword", text: $signUpViewModel.signUpModel.password, type: .password)
                    .validation(signUpViewModel.signUpModel.passwordValidation)
                BaseTextField("Email", text: $signUpViewModel.signUpModel.email, type: .emailAddress)
                    .validation(signUpViewModel.signUpModel.emailValidation)
                
                NavigationLink(
                    destination: VerificationView(
                        verificationViewModel: VerificationViewModel(
                            gameTrackerFetcher: GameTrackerFetcher(),
                            username: signUpViewModel.signUpModel.username)),
                    isActive: $signUpViewModel.successfulSignUp
                ) {
                    Button(action: {
                        signUpViewModel.signUp(username: signUpViewModel.signUpModel.username,
                                               password: signUpViewModel.signUpModel.password,
                                               email: signUpViewModel.signUpModel.email)
                    }, label: {
                        Text("Sign Up")
                    })
                    .disabled(isSaveDisabled)
                }
            }
        }
        .onReceive(signUpViewModel.signUpModel.allValidation) { validation in
            isSaveDisabled = !validation.isSuccess
        }
    }
}

struct ValidationModifier: ViewModifier {
    @State var latestValidation: Validation = .success
    
    let validationPublisher: ValidationPublisher
    
    func body(content: Content) -> some View {
        return VStack(alignment: .leading) {
            content
            validationMessage
        }.onReceive(validationPublisher) { validation in
            self.latestValidation = validation
        }
    }
    
    var validationMessage: some View {
        switch latestValidation {
        case .success:
            return AnyView(EmptyView())
        case .failure(let message):
            let text = Text(message)
                .foregroundColor(Color.red)
                .font(.caption)
                .padding(.init(top: 0, leading: 15, bottom:0 , trailing: 15))
            return AnyView(text)
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
        SignUpView(signUpViewModel: SignUpViewModel(gameTrackerFetcher: GameTrackerFetcher(), signUpModel: SignUpModel()))
    }
}
