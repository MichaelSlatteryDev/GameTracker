//
//  ProgressBar.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/17/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        GeometryReader() { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width/2, height: geometry.size.height)
                    .opacity(0.3)
                    .border(Color.black, width: 2)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                Rectangle().frame(width: min(CGFloat(self.progress)*geometry.size.width/2, geometry.size.width/2), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear)
            }
            .cornerRadius(45.0)
            .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        }
        .frame(height: 10)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: Binding.constant(20/49))
    }
}
