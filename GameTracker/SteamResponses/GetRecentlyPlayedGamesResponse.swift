//
//  GetRecentlyPlayedGamesResponse.swift
//  GameTracker
//
//  Created by Michael Slattery on 10/20/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation

struct GetRecentlyPlayedGamesResponse: Codable {
    let response: RecentlyPlayedGames
}

struct RecentlyPlayedGames: Codable {
    let totalCount: Int
    let games: [Game]
}
