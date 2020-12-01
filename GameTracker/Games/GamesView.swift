//
//  GamesView.swift
//  GameTracker
//
//  Created by Michael Slattery on 11/21/20.
//  Copyright © 2020 Michael Slattery. All rights reserved.
//

import SwiftUI
import QGrid

struct GamesView: View {
    
    @StateObject
    var gamesViewModel: GamesViewModel
    
    var body: some View {
        BaseView {
            QGrid(gamesViewModel.allGames, columns: 3) { game in
                GameCell(cellData: game, view: .games, errorHandler: gamesViewModel.getIGDBGames(name: completion:))
            }
        }.onAppear {
            gamesViewModel.fetchAllGames()
        }
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView(gamesViewModel: GamesViewModel(steamFetcher: SteamFetcher(), igdbFetcher: IGDBFetcher()))
    }
}
