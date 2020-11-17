//
//  MainView.swift
//  GameTracker
//
//  Created by Michael Slattery on 8/23/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

private let buttonSize: CGFloat = 48.0
private let buttonCornerRadius: CGFloat = 25.0
private let buttonBorderLineWidth: CGFloat = 2.0

struct MainView: View {
    
    @StateObject
    var mainViewModel: MainViewModel
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        BaseView {
            VStack {
                Text("Hello \(User.shared.username)!")
                    .foregroundColor(.white)
                .padding()
                HStack {
                    Spacer()
                    GameTrackerButton(image: "gamecontroller.fill", action: {
                        print("Access Library")
                    })
                    Spacer()
                    GameTrackerButton(image: "gearshape.fill", action: {
                        print("Access Settings")
                    })
                    Spacer()
                }
                VStack(spacing: 0) {
                    if verticalSizeClass == .compact, let gameCell = mainViewModel.mostRecent().first {
                        GameCellView(gameCell: gameCell)
                    } else {
                        ForEach(mainViewModel.mostRecent()) { gameCell in
                            GameCellView(gameCell: gameCell)
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottomLeading)
            }
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
                .stroke(Color.white, lineWidth: buttonBorderLineWidth)
            )
        }
    }
}

struct GameCellView: View {
    var gameCell: MainModel.GameCell
     
    var body: some View {
        Button(action: {
            print(gameCell.name)
        }) {
            VStack {
                WebImage(url: URL(string: gameCell.background))
                    .resizable()
                    .indicator(.activity)
                    .scaledToFit()
                HStack {
                    if let total = gameCell.totalAchievements, let completed = gameCell.completedAchievements {
                        Text("\(gameCell.name):")
                            .foregroundColor(.white)
                        ProgressBar(progress: Binding.constant(Float(completed)/Float(total)))
                    } else {
                        Text("\(gameCell.name) has no achievements")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(mainViewModel: MainViewModel(steamFetcher: SteamFetcher()))
    }
}
