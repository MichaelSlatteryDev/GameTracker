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
    let gamesViewModel = GamesViewModel(steamFetcher: SteamFetcher(), igdbFetcher: IGDBFetcher())
    
    @State var showAllGames = false
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            BaseView {
                VStack {
                    Text("Hello \(User.shared.username)!")
                        .foregroundColor(.white)
                    .padding()
                    HStack {
                        Spacer()
                        NavigationLink(destination: GamesView(gamesViewModel: gamesViewModel), isActive: $showAllGames) {
                            GameTrackerButton(image: "gamecontroller.fill", action: {
                                print("Access Library")
                                showAllGames = true
                            })
                        }
                        Spacer()
                        GameTrackerButton(image: "gearshape.fill", action: {
                            print("Access Settings")
                        })
                        Spacer()
                    }
                    VStack(spacing: 0) {
                        if verticalSizeClass == .compact, let gameCell = mainViewModel.mostRecent().first {
                            GameCell(cellData: gameCell, view: .main)
                        } else {
                            ForEach(mainViewModel.mostRecent()) { gameCell in
                                GameCell(cellData: gameCell, view: .main)
                            }
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottomLeading)
                }
            }
        }
        .navigationBarHidden(true)
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

struct GameCell: View {
    var cellData: MainModel.GameCell
    var view: MainModel.GameCellView
    var errorHandler: ((String) -> ())?
     
    var body: some View {
        switch (view) {
        case .main: GameCellLandscape(cellData: cellData)
        case .games: GameCellPortrait(cellData: cellData, errorHandler: errorHandler)
        }
    }
}

struct GameCellPortrait: View {
    var cellData: MainModel.GameCell
    var errorHandler: ((String) -> ())?
    
    var body: some View {
        WebImage(url: URL(string: cellData.background))
            .onFailure(perform: { error in
                print(error)
                if let errorHandler = errorHandler {
                    errorHandler(cellData.name)
                }
//                cellData.background = cellData.backupBackground
            })
            .onSuccess(perform: { _ in
                print(cellData.name)
            })
            .resizable()
            .indicator(.activity)
            .frame(width: 100, height: 150, alignment: .center)
//            .scaledToFit()
    }
}

struct GameCellLandscape: View {
    var cellData: MainModel.GameCell
    
    var body: some View {
        Button(action: {
            print(cellData.name)
        }) {
            VStack {
                if let total = cellData.totalAchievements, let completed = cellData.completedAchievements {
                    WebImage(url: URL(string: cellData.background))
                        .resizable()
                        .indicator(.activity)
                        .overlay(
                            GeometryReader { geometry in
                                VStack(alignment: .leading) {
                                    StrokeText(text: "\(cellData.name)")
                                    StrokeText(text: "Progress: \(completed)\\\(total)")
                                }
                            }
                        )
                        .scaledToFit()
                } else {
                    WebImage(url: URL(string: cellData.background))
                        .resizable()
                        .indicator(.activity)
                        .overlay(
                            GeometryReader { geometry in
                                VStack(alignment: .leading) {
                                    StrokeText(text: "\(cellData.name) has no achievements")
                                }
                            }
                        )
                        .scaledToFit()
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
