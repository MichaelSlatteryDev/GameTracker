//
//  Endpoints.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/23/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation

enum Endpoints {
    
    // Steam
    case getOwnedGames
    case getRecentlyPlayedGames
    case getPlayerSummary
    case getPlayerAchievements
    case getUserStatsForGame
    
    //Twitch
    case getTwitchToken
    
    //IGDB
    case getIGDBCover
    
    func path() -> String {
        switch (self) {
        case .getOwnedGames: return "/IPlayerService/GetOwnedGames/v1/"
        case .getRecentlyPlayedGames: return "/IPlayerService/GetRecentlyPlayedGames/v1/"
        case .getPlayerSummary: return "/ISteamUser/GetPlayerSummaries/v2/"
        case .getPlayerAchievements: return "/ISteamUserStats/GetPlayerAchievements/v0001/"
        case .getUserStatsForGame: return "/ISteamUserStats/GetUserStatsForGame/v0002/"
        case .getTwitchToken: return "/oauth2/token"
        case .getIGDBCover: return "/v4/covers"
        }
    }
}
