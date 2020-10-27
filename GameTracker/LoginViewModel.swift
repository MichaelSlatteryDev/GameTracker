//
//  LoginViewModel.swift
//  GameTracker
//
//  Created by Michael Slattery on 10/26/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI
import SteamLogin
import Combine

class LoginViewModel: ObservableObject, Identifiable {
    
    var handler: SteamLoginVCHandler = { user, error in
        
    }
    
    init() {
        
    }
}
