//
//  GetPlayerAchievementsResponse.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/16/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation

struct GetPlayerAchievementsResponse: Codable {
    let playerstats: PlayerStats
}

struct PlayerStats: Codable {
    let steamID: String
    let gameName: String
    let achievements: [Achievement]
    let success: Bool
}

struct Achievement: Codable {
    let apiname: String
    let achieved: Int
    let unlocktime: Int
}
