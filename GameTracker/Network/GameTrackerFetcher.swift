//
//  GameTrackerFetcher.swift
//  GameTracker
//
//  Created by Michael Slattery on 1/4/21.
//  Copyright © 2021 Michael Slattery. All rights reserved.
//

import Foundation
import Combine
import Amplify

class GameTrackerFetcher: Fetcher {
    
    func signUp(username: String, password: String, email: String) -> AuthSignUpOperation {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        return Amplify.Auth.signUp(username: username, password: password, options: options)
    }
}
