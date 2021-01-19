//
//  BaseTextField.swift
//  GameTracker
//
//  Created by Michael Slattery on 1/6/21.
//  Copyright © 2021 Michael Slattery. All rights reserved.
//

import SwiftUI

struct BaseTextField: View {
    
    var titleKey: LocalizedStringKey
    var text: Binding<String>
    var textContentType: UITextContentType
    var isActive: Bool
    
    init(_ titleKey: LocalizedStringKey, text: Binding<String>, type textContentType: UITextContentType, isActive: Bool = false) {
        self.titleKey = titleKey
        self.text = text
        self.textContentType = textContentType
        self.isActive = isActive
    }
    
    var body: some View {
        switch textContentType {
        case .password:
            SecureField(titleKey, text: text)
                .accentColor(.black)
                .autocapitalization(.none)
                .padding(.init(top: 0, leading: 15, bottom:0 , trailing: 15))
                .textFieldStyle(RoundedBorderTextFieldStyle.init())
                .introspectTextField  { textField in
                    if isActive && textField.text == "" {
                        textField.becomeFirstResponder()
                    }
                }
        default:
            TextField(titleKey, text: text)
                .textContentType(textContentType)
                .accentColor(.black)
                .autocapitalization(.none)
                .padding(.init(top: 0, leading: 15, bottom:0 , trailing: 15))
                .textFieldStyle(RoundedBorderTextFieldStyle.init())
                .introspectTextField  { textField in
                    if isActive && textField.text == "" {
                        textField.becomeFirstResponder()
                    }
                }
        }
    }
}

struct BaseTextField_Previews: PreviewProvider {
    static var previews: some View {
        BaseTextField("Example", text: Binding.constant(""), type: .username)
    }
}
