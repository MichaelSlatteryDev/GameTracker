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
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    
    var body: some View {
        BaseView {
            VStack {
                BaseTextField("Username", text: $username, type: .username)
                BaseTextField("Pasword", text: $password, type: .password)
                BaseTextField("Email", text: $email, type: .emailAddress)
                Button(action: {
                    signUpViewModel.signUp(username: username, password: password, email: email)
                }, label: {
                    Text("Sign Up")
                })
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(signUpViewModel: SignUpViewModel(gameTrackerFetcher: GameTrackerFetcher()))
    }
}
