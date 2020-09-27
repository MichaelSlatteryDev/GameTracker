//
//  GetOwnedGamesResponse.swift
//  GameTracker
//
//  Created by Michael Slattery on 9/13/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation

struct GetOwnedGamesResponse: Codable {
    let response: OwnedGames
}

struct OwnedGames: Codable {
    let gameCount: Int
    let games: [Game]
}

struct Game: Codable {
    let appid: Int
    let name: String
    let playtimeForever: Int
    let imgIconUrl: String
    let imgLogoUrl: String
    let hasCommunityVisibleStats: Bool?
    let playtimeWindowsForever: Int
    let playtimeMacForever: Int
    let playtimeLinuxForever: Int
}
