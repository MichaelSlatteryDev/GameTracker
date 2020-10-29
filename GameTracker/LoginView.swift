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
        NavigationView {
            NavigationLink(destination: MainView(mainViewModel: MainViewModel(steamFetcher: SteamFetcher())),
                           isActive: $loginViewModel.successfulLogin, label: {
                Button(action: {
                    self.showSafari = true
                }) {
                    Text("Steam Login")
                }
                .sheet(isPresented: $showSafari) {
                    SafariView(handler: loginViewModel.handler)
                }
            })
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    
    let handler: SteamLoginVCHandler
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SteamLoginVC {
        return SteamLoginVC.init(loginHandler: handler)
    }

    func updateUIViewController(_ uiViewController: SteamLoginVC, context: UIViewControllerRepresentableContext<SafariView>) {

    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginViewModel: LoginViewModel(steamFetcher: SteamFetcher()))
    }
}
