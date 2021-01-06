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
    
    init(_ titleKey: LocalizedStringKey, text: Binding<String>, type textContentType: UITextContentType) {
        self.titleKey = titleKey
        self.text = text
        self.textContentType = textContentType
    }
    
    var body: some View {
        switch textContentType {
        case .password:
            SecureField(titleKey, text: text)
                .accentColor(.black)
                .autocapitalization(.none)
                .padding(.init(top: 0, leading: 15, bottom:0 , trailing: 15))
                .textFieldStyle(RoundedBorderTextFieldStyle.init())
        default:
            TextField(titleKey, text: text)
                .textContentType(textContentType)
                .accentColor(.black)
                .autocapitalization(.none)
                .padding(.init(top: 0, leading: 15, bottom:0 , trailing: 15))
                .textFieldStyle(RoundedBorderTextFieldStyle.init())
        }
    }
}

struct BaseTextField_Previews: PreviewProvider {
    static var previews: some View {
        BaseTextField("Example", text: Binding.constant(""), type: .username)
    }
}
