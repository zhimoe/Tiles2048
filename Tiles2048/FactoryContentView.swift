//
//  FactoryView.swift
//  Tiles2048
//
//  Created by zhimoe on 2023/5/28.
//

import SwiftUI

struct FactoryContentView<G: Gesture>: View {

    var gesture: G
    
    @ObservedObject var gameLogic: GameLogic
    
    @Binding var presentEndGameModal: Bool

    @ViewBuilder var body: some View {
        currentView()
            .modifier(SlideViewModifier(gesture: gesture,
                                        presentEndGameModal: $presentEndGameModal))
    }

    // MARK: - Private Properties
    
    private var tileBoardView: some View {
       return  BoardView(
        matrix: gameLogic.tiles,
                      tileEdge: gameLogic.lastGestureDirection.invertedEdge,
                      tileBoardSize: gameLogic.boardSize)

    }

    
    // MARK: - Private Methods
    @ViewBuilder
    private func currentView() -> some View {
        tileBoardView
    }
}

struct SlideViewModifier<T: Gesture>: ViewModifier {
    var gesture: T
    @Binding var presentEndGameModal: Bool
    
    func body(content: Content) -> some View {
        content
            .gesture(gesture, including: .all)
            .scaleEffect((presentEndGameModal) ? 0.9 : 1.0)
            .allowsHitTesting(!(presentEndGameModal))
    }
}


