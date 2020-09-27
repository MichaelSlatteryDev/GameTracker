//
//  SteamError.swift
//  GameTracker
//
//  Created by Michael Slattery on 9/13/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation

enum SteamError: Error {
    case parsing(description: String)
    case network(description: String)
}
