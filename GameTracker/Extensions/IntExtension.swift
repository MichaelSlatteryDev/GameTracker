//
//  IntExtension.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/21/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation

extension Int {
    func toHoursAndMinutes() -> String {
        let hours = self / 60
        let minutes = self % 60
        return "\(hours):\(minutes)"
    }
}
