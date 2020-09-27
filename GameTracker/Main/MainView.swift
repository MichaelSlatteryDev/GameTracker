//
//  MainView.swift
//  GameTracker
//
//  Created by Michael Slattery on 8/23/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI

private let buttonSize: CGFloat = 48.0
private let buttonCornerRadius: CGFloat = 25.0
private let buttonBorderLineWidth: CGFloat = 2.0

struct MainView: View {
    
    @ObservedObject
    var mainViewModel: MainViewModel
    
    var body: some View {
        VStack {
            Text("Hello, \(mainViewModel.mainModel.username)!")
            .padding()
            HStack {
                Spacer()
                GameTrackerButton(image: "gamecontroller.fill", action: {
                    print("Access Library")
                })
                Spacer()
                GameTrackerButton(image: "gamecontroller.fill", action: {
                    print("Access Settings")
                })
                Spacer()
            }
            VStack {
                ForEach(mainViewModel.mostRecent()) { gameCell in
                    GameCellView(gameCell: gameCell)
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottomLeading)
        }
    }
}

struct GameTrackerButton: View {
    var image: String
    var action: () -> ()
    var size: CGFloat = buttonSize
    var cornerRadius: CGFloat = buttonCornerRadius
    var lineWith: CGFloat = buttonBorderLineWidth
    
    var body : some View {
        Button(action: action) {
            Image(systemName: image)
            .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
            .scaledToFit()
            .frame(width: buttonSize, height: buttonSize)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: buttonCornerRadius)
                .stroke(Color.blue, lineWidth: buttonBorderLineWidth)
            )
        }
    }
}

struct GameCellView: View {
    var gameCell: MainModel.GameCell
     
    var body: some View {
        Button(action: {
            print("Access Game")
        }) {
            HStack {
                Text(gameCell.name)
                Spacer()
                Text(gameCell.hoursPlayed)
            }
        }
        .background(Image(gameCell.background))
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(mainViewModel: MainViewModel(steamFetcher: SteamFetcher()))
    }
}
