//
//  StrokeText.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/19/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI

struct StrokeText: View {
    let text: String
    var width: CGFloat = 0.5
    var strokeColor: Color = .black
    var textColor: Color = .white

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(strokeColor)
            Text(text)
                .foregroundColor(textColor)
        }
    }
}

struct StrokeText_Previews: PreviewProvider {
    static var previews: some View {
        StrokeText(text: "Hello World!", strokeColor: .red, textColor: .white)
    }
}
