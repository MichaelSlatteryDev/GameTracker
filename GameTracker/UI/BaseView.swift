//
//  BaseView.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/17/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI

struct BaseView<Content: View>: View {
    var content: () -> Content

    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
            content()
        }
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView {}
    }
}
