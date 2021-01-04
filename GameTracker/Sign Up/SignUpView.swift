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
                TextField("Username", text: $username)
                    .textContentType(.username)
                    .accentColor(.black)
                    .padding(.init(top: 0, leading: 15, bottom:0 , trailing: 15))
                    .textFieldStyle(RoundedBorderTextFieldStyle.init())
                SecureField("Pasword", text: $password)
                    .textContentType(.password)
                    .accentColor(.black)
                    .padding(.init(top: 0, leading: 15, bottom:0 , trailing: 15))
                    .textFieldStyle(RoundedBorderTextFieldStyle.init())
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .accentColor(.black)
                    .padding(.init(top: 0, leading: 15, bottom:0 , trailing: 15))
                    .textFieldStyle(RoundedBorderTextFieldStyle.init())
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
