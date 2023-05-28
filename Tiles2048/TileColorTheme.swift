//
//  TileColorTheme.swift
//  Tiles2048
//
//  Created by zhimoe on 2023/5/27.
//

import Foundation
import SwiftUI

struct TileColorTheme{
    typealias ColorPair = (background: Color, font: Color)
    
    var lightTileColors: [ColorPair] = [
        (Color(red:0.91, green:0.87, blue:0.83, opacity:1.00), Color(red:0.42, green:0.39, blue:0.35, opacity: 1.00)), // 2
        (Color(red:0.90, green:0.86, blue:0.76, opacity:1.00), Color(red:0.42, green:0.39, blue:0.35, opacity: 1.00)), // 4
        (Color(red:0.93, green:0.67, blue:0.46, opacity:1.00), Color.white), // 8
        (Color(red:0.94, green:0.57, blue:0.38, opacity:1.00), Color.white), // 16
        (Color(red:0.95, green:0.46, blue:0.33, opacity:1.00), Color.white), // 32
        (Color(red:0.94, green:0.35, blue:0.23, opacity:1.00), Color.white), // 64
        (Color(red:0.91, green:0.78, blue:0.43, opacity:1.00), Color.white), // 128
        (Color(red:0.91, green:0.78, blue:0.37, opacity:1.00), Color.white), // 256
        (Color(red:0.90, green:0.77, blue:0.31, opacity:1.00), Color.white), // 512
        (Color(red:0.91, green:0.75, blue:0.24, opacity:1.00), Color.white), // 1024
        (Color(red:0.91, green:0.74, blue:0.18, opacity:1.00), Color.white), // 2048
        (Color(red:0.91, green:0.72, blue:0.12, opacity:1.00), Color.white), // 4096
    ]
    
    func colorPair(for index:Int?, defaultColor:Color) -> ColorPair {
        // return default color for background and black font when index is nil
        guard let number = index else {
            return (defaultColor,Color.black)
        }
        let index = Int(log2(Double(number))) - 1
        
        if index < 0 || index >= lightTileColors.count {
            fatalError("No color for such a number")
        }
        
        return lightTileColors[index]
    }
    
}
