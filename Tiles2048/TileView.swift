//
//  TileView.swift
//  Tiles2048
//
//  Created by zhimoe on 2023/5/27.
//

import SwiftUI

struct TileView: View {
    
    private var tileColorTheme = TileColorTheme()
    private var backgroundColor:Color {
        Color(red:0.78, green:0.73, blue:0.68, opacity: 1.0)
    }
    private let number: Int?
    private let textId: String
    private let fontProportionalWidth: CGFloat = 3
    
    init(number:Int){
        self.number = number
        textId = "\(number)"
    }
    
    
    private init() {
        number = nil
        textId = ""
    }
    
    static func empty() -> Self {
        return self.init()
    }
    
    var body: some View {
        let tileColorTheme = self.tileColorTheme.colorPair(for: number, defaultColor: self.backgroundColor)
        
        return GeometryReader { proxy in
            ZStack{
                Rectangle().fill(tileColorTheme.background)
                
                Text(title())
                    .font(.system(size: fontSize(proxy),weight: .bold,design: .monospaced))
                    .id(number)
                    .foregroundColor(tileColorTheme.font)
                    .transition(
                        AnyTransition
                            .scale(scale: 0.2)
                            .combined(with: .opacity)
                            .animation(.modalSpring(duration:0.3))
                    )
            }
            
        }
    }
    
    private func title() -> String {
        guard let number = self.number else {
            return ""
        }
        return String(number)
    }
    
    private func fontSize(_ proxy: GeometryProxy) -> CGFloat {
        proxy.size.width / fontProportionalWidth
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        TileView(number: 16)
    }
}

extension Animation {
    public static var modalSpring: Animation {
        .spring(response: 0.5, dampingFraction: 0.777, blendDuration: 0)
    }
    
    public static func modalSpring(duration: Double) -> Animation {
        .spring(response: 0.5, dampingFraction: 0.777, blendDuration: duration)
    }
}
