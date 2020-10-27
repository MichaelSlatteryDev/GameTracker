//
//  User.swift
//  GameTracker
//
//  Created by Michael Slattery on 10/26/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation

class User {

    static let shared = User()
    
    private(set) var username: String = ""
    private(set) var firstName: String = ""
    private(set) var lastName: String = ""
    private(set) var steamId: String?
    
    private init() {}
    
    func updateUserInfo(username: String,
                        firstName: String,
                        lastName: String,
                        steamId: String? = nil) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.steamId = steamId
    }
    
    func cleareUserInfo() {
        self.username = ""
        self.firstName = ""
        self.lastName = ""
        self.steamId = ""
    }
}
