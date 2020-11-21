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
    
    @StateObject
    var loginViewModel: LoginViewModel
    
    @State var showSafari = false
    
    var body: some View {
        NavigationView {
            BaseView {
                NavigationLink(destination: MainView(mainViewModel: MainViewModel(steamFetcher: SteamFetcher())), isActive: $loginViewModel.successfulLogin) {
                    Button(action: {
                        self.showSafari = true
                    }) {
                        Image("steam_login")
                    }
                    .sheet(isPresented: $showSafari) {
                        SafariView(handler: loginViewModel.handler)
                    }
                }
            }
        }
        .accentColor(.white)
        .navigationBarHidden(true)
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
