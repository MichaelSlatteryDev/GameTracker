//
//  SignUpModel.swift
//  GameTracker
//
//  Created by Michael Slattery on 1/6/21.
//  Copyright © 2021 Michael Slattery. All rights reserved.
//

import Combine

// This is a class instead of a struct so it can implement ObservableObject. It implements ObservableObject because each
// value need to be published so the UI can be updated.
class SignUpModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    
    lazy var usernameValidation: ValidationPublisher = {
        $username.validateSize(errorMessage: "First name must be provided")
    }()
    
    lazy var passwordValidation: ValidationPublisher = {
        $password.validateSize(size: 5, errorMessage: "Password must be 6 or more characters long")
    }()
    
    lazy var emailValidation: ValidationPublisher = {
        $email.validateEmail(errorMessage: "Email not valid")
    }()
    
    lazy var allValidation: ValidationPublisher = {
        Publishers.CombineLatest3(
            usernameValidation,
            passwordValidation,
            emailValidation
        ).map { val1, val2, val3 in
            return [val1, val2, val3].allSatisfy { $0.isSuccess } ? .success : .failure(message: "")
        }
        .eraseToAnyPublisher()
    }()
}
