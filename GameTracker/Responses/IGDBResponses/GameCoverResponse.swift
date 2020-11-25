//
//  GameCoverResponse.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/25/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation

struct GameCoverResponse: Codable {
    let id: String
    let alphaChannel: Bool
    let animated: Bool
    let game: Int
    let height: Int
    let imageId: String
    let url: String
    let width: Int
    let checksum: String
}
