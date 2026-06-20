//
//  Palette.swift
//  reward-jar
//

import SwiftUI

enum Palette {
    static let starFill = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.88, blue: 0.95),
            Color(red: 1.0, green: 0.55, blue: 0.78),
            Color(red: 0.78, green: 0.12, blue: 0.40)
        ],
        startPoint: .top, endPoint: .bottom
    )
    static let starStroke = Color(red: 0.45, green: 0.05, blue: 0.22)
    static let starTint = Color(red: 0.92, green: 0.25, blue: 0.50)

    static let gemFill = LinearGradient(
        colors: [
            Color(red: 0.90, green: 0.78, blue: 1.0),
            Color(red: 0.65, green: 0.42, blue: 0.95),
            Color(red: 0.28, green: 0.08, blue: 0.62)
        ],
        startPoint: .top, endPoint: .bottom
    )
    static let gemStroke = Color(red: 0.15, green: 0.03, blue: 0.42)
    static let gemTint = Color(red: 0.50, green: 0.22, blue: 0.85)

    static let lidFill = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.82, blue: 0.48),
            Color(red: 0.95, green: 0.55, blue: 0.20)
        ],
        startPoint: .top, endPoint: .bottom
    )
    static let lidStroke = Color(red: 0.55, green: 0.28, blue: 0.05)

    static let glassFill = LinearGradient(
        colors: [
            Color(red: 0.78, green: 0.93, blue: 1.0).opacity(0.75),
            Color(red: 0.55, green: 0.80, blue: 0.95).opacity(0.45)
        ],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let glassStroke = Color(red: 0.30, green: 0.50, blue: 0.65).opacity(0.7)
}
