//
//  GetPlayerSummariesResponse.swift
//  GameTracker
//
//  Created by Michael Slattery on 10/26/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation

struct GetPlayerSummariesResponse: Codable {
    let response: PlayerSummaries
}

struct PlayerSummaries: Codable {
    let players: [Player]
}

struct Player: Codable {
    let steamid: String
    let communityvisibilitystate: Int
    let profilestate: Int
    let personaname: String
    let profileurl: String
    let avatar: String
    let avatarmedium: String
    let avatarfull: String
    let avatarhash: String
    let lastlogoff: Int
    let personastate: Int
    let primaryclanid: String
    let timecreated: Int
    let personastateflags: Int
}
