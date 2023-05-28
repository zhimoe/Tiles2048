//
//  Tiles2048App.swift
//  Tiles2048
//
//  Created by zhimoe on 2023/5/27.
//

import SwiftUI

@main
struct Tiles2048App: App {
    
    private var mainView: some View {
        let boardSize = BoardSize.fourByFour
        let initialBoardSizeRawValue = boardSize.rawValue
    
        return GameView(board: GameLogic(size: initialBoardSizeRawValue))
    }
    
    var body: some Scene {
        WindowGroup {
            mainView
        }
    }
}

enum BoardSize: Int, Codable {
    case threeByThree = 3
    case fourByFour = 4
    case fiveByFive = 5
}
