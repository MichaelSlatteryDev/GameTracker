//
//  SplashView.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/19/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    
    let loginView = LoginView(loginViewModel: LoginViewModel(steamFetcher: SteamFetcher()))
    let mainView = MainView(mainViewModel: MainViewModel(steamFetcher: SteamFetcher()))
    
    @StateObject
    var splashViewModel: SplashViewModel
    
    var body: some View {
        if splashViewModel.savedCredentials {
            NavigationView {
                BaseView {
                    ProgressView()
                        .colorInvert()
                    NavigationLink(destination: mainView, isActive: $splashViewModel.successfulLogin) {
                        Text("")
                    }.hidden()
                }
            }
        } else {
            loginView
        }
    }
}

struct SplashViewView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(splashViewModel: SplashViewModel(steamFetcher: SteamFetcher()))
    }
}
