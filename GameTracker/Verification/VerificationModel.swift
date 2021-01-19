//
//  VerificationModel.swift
//  GameTracker
//
//  Created by Michael Slattery on 1/18/21.
//  Copyright © 2021 Michael Slattery. All rights reserved.
//

import Foundation

struct VerificationModel {
    
    var username: String
    
    struct Code {
        var firstDigit: String = ""
        var secondDigit: String = ""
        var thirdDigit: String = ""
        var fourthDigit: String = ""
        var fifthDigit: String = ""
        var sixthDigit: String = ""
        
        lazy var allDigits: String = {
            firstDigit + secondDigit + thirdDigit + fourthDigit + fifthDigit + sixthDigit
        }()
    }
}
