//
//  NetworkError    .swift
//  GameTracker
//
//  Created by Michael Slattery on 9/13/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case parsing(description: String)
    case url(description: String)
}
