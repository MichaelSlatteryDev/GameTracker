//
//  LoginView.swift
//  GameTracker
//
//  Created by Michael Slattery on 10/21/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI
import SteamLogin

struct LoginView: View {
    
    @ObservedObject
    var loginViewModel: LoginViewModel
    
    @State var showSafari = false
    
    var body: some View {
        Button(action: {
            self.showSafari = true
        }) {
            Text("Steam Login")
        }
        // summon the Safari sheet
        .sheet(isPresented: $showSafari) {
            SafariView(handler: loginViewModel.handler)
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    
    let handler: SteamLoginVCHandler
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SteamLoginVC {
        return SteamLoginVC.init { (user, error) in
            if let user = user {
                print(user.steamID64)
            } else {
                print(error)
            }
        }
    }

    func updateUIViewController(_ uiViewController: SteamLoginVC, context: UIViewControllerRepresentableContext<SafariView>) {

    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginViewModel: LoginViewModel())
    }
}
