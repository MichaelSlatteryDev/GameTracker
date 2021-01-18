//
//  ValidationPublishers.swift
//  GameTracker
//
//  Created by Michael Slattery on 1/6/21.
//  Copyright © 2021 Michael Slattery. All rights reserved.
//

import SwiftUI
import Combine

typealias ValidationErrorClosure = () -> String
typealias ValidationPublisher = AnyPublisher<Validation, Never>

enum Validation {
    case success
    case failure(message: String)
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}

class ValidationPublishers {
    static func sizeValidation(for publisher: Published<String>.Publisher, size: Int,
                                       errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return publisher.map { value in
            guard value.count > size else {
                return .failure(message: errorMessage())
            }
            return .success
        }
        .dropFirst()
        .eraseToAnyPublisher()
    }
    
    static func emailValidation(for publisher: Published<String>.Publisher,
                                errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return publisher.map { email in
            guard email.isEmail() else {
                return .failure(message: errorMessage())
            }
            return .success
        }
        .dropFirst()
        .eraseToAnyPublisher()
    }
}

extension Published.Publisher where Value == String {
    func validateSize(size: Int = 0, errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.sizeValidation(for: self, size: size, errorMessage: errorMessage())
    }
    
    func validateEmail(errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.emailValidation(for: self, errorMessage: errorMessage())
    }
}
