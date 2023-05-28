//
//  GameView.swift
//  Tiles2048
//
//  Created by zhimoe on 2023/5/28.
//

import SwiftUI
import Combine

struct GameView: View {
    // MARK: - Proeprties
    @ObservedObject private var logic: GameLogic
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @State private var ignoreGesture = false
    @State private var presentEndGameModal = false
    @State private var hasGameEnded = false
    @State private var viewState = CGSize.zero
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    private var colorSchemeBackgroundTheme :Color{
        Color(red:0.90, green:0.90, blue:0.90, opacity:1.00)
    }

    @State private var score: Int = 0
    @State private var scoreMultiplier: Int = 0
    
 
    // MARK: - Initializers
    
    init(board: GameLogic) {
        self.logic = board
    }
    
    private var gesture: some Gesture {
        let threshold: CGFloat = 25
        
        let drag = DragGesture()
            .onChanged { v in
                guard !ignoreGesture else { return }
                
                guard abs(v.translation.width) > threshold ||
                    abs(v.translation.height) > threshold else {
                        return
                }
                
                withTransaction(Transaction()) {
                    ignoreGesture = true
                    
                    if v.translation.width > threshold {
                        // Move right
                        logic.move(.right)
                    } else if v.translation.width < -threshold {
                        // Move left
                        logic.move(.left)
                    } else if v.translation.height > threshold {
                        // Move down
                        logic.move(.down)
                    } else if v.translation.height < -threshold {
                        // Move up
                        logic.move(.up)
                    }
                }
        }
        .onEnded { _ in
            ignoreGesture = false
        }
        return drag
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                VStack {
                    Text("Tiles")
                        .font(.system(size: 14, weight: .bold,design: .monospaced))
                    Group {
                        FactoryContentView(
                            gesture: gesture,
                            gameLogic: logic,
                            presentEndGameModal: $presentEndGameModal
                        )
                        .onReceive(logic.$score) { (publishedScore) in
                            score = publishedScore
                        }
                        .onReceive(logic.$mergeMultiplier) { (publishedScoreMultiplier) in
                            scoreMultiplier = publishedScoreMultiplier
                        }
                        .onReceive(logic.$hasMoveMergedTiles) { hasMergedTiles in
                           
                        }
                    }
                    .blur(radius: (presentEndGameModal) ? 4 : 0)
                }
                .modifier(RoundedClippedBackground(backgroundColor: colorSchemeBackgroundTheme,
                                                   proxy: proxy))
                .modifier(
                    MainViewModifier(
                        proxy: proxy,
                        presentEndGameModal: $presentEndGameModal,
                        viewState: $viewState
                    )
                )
                .onTapGesture {
                    guard !hasGameEnded else { return } // Disable on tap dismissal of the end game modal view
                        withAnimation(.modalSpring) {
                            presentEndGameModal = false
                        }
                }
                .onReceive(logic.$noPossibleMove) { (publisher) in
                    let hasGameEnded = logic.noPossibleMove
                    self.hasGameEnded = hasGameEnded
                    
                    withAnimation(.modalSpring) {
                        self.presentEndGameModal = hasGameEnded
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(board:GameLogic(size: 4))
    }
}


struct RoundedClippedBackground: ViewModifier {
    let backgroundColor: Color
    let proxy: GeometryProxy

    func body(content: Content) -> some View {
        content
            .background(Rectangle().fill(backgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.primary.opacity(0.3), radius: 20)
    }
}

struct MainViewModifier: ViewModifier {
    let proxy: GeometryProxy
    @Binding var presentEndGameModal: Bool
    @Binding var viewState: CGSize
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    func body(content: Content) -> some View {
        content
            .offset(y: presentEndGameModal ? horizontalSizeClass == .regular ? (proxy.size.width < proxy.size.height ? -proxy.size.height / 4 : -proxy.size.height / 3) : -proxy.size.height / 3 : 0)
            .rotation3DEffect(Angle(degrees: presentEndGameModal ? proxy.size.width < proxy.size.height ? Double(viewState.height / 10) - 10 : Double(viewState.height / 10) - 20 : 0), axis: (x: 10.0, y: 0, z: 0))
            .scaleEffect(presentEndGameModal ? 0.9 : 1)
            .rotation3DEffect(Angle(degrees: 0), axis: (x: 0, y: 10, z: 0))
            .offset(x: -viewState.width)
            .scaleEffect(1)
    }
}

