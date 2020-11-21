//
//  MainModel.swift
//  GameTracker
//
//  Created by Michael Slattery on 8/23/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation

struct MainModel {
    enum GameCellView {
        case main
        case games
    }
    
    struct GameCell: Identifiable {
        var id: Int
        var name: String
        var hoursPlayed: String
        var background: String
        var completedAchievements: Int?
        var totalAchievements: Int?
    }
}
