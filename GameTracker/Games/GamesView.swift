//
//  GamesView.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/21/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI

struct GamesView: View {
    
    @StateObject
    var gamesViewModel: GamesViewModel
    
    var body: some View {
        BaseView {
            ScrollView {
                LazyVStack {
                    ForEach(gamesViewModel.allGamesSeperated()) { _ in
                        GameRow(games: gamesViewModel.allGamesSubList(), errorHandler: gamesViewModel.getIGDBGames(name:))
                    }
                }
            }
        }
    }
}

struct GameRow: View {
    var games: [MainModel.GameCell] = []
    var errorHandler: ((String) -> ())?
    
    var body: some View {
        LazyHStack {
            ForEach(games) { game in
                GameCell(cellData: game, view: .games, errorHandler: errorHandler)
            }
        }
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView(gamesViewModel: GamesViewModel(steamFetcher: SteamFetcher(), igdbFetcher: IGDBFetcher()))
    }
}
