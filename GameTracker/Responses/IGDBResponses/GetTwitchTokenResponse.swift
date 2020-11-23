//
//  GetTwitchTokenResponse.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/23/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation

struct TwitchTokenResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
}
