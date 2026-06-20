//
//  Background.swift
//  reward-jar
//

import SwiftUI

struct ModernBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 1.00, green: 0.83, blue: 0.92),
                    Color(red: 1.00, green: 0.94, blue: 0.97),
                    Color(red: 0.90, green: 0.85, blue: 1.00)
                ],
                startPoint: UnitPoint(x: 0.05, y: 0.0),
                endPoint: UnitPoint(x: 0.95, y: 1.0)
            )

            RadialGradient(
                colors: [
                    Color(red: 1.00, green: 0.80, blue: 0.72).opacity(0.55),
                    Color.clear
                ],
                center: UnitPoint(x: 0.85, y: 0.12),
                startRadius: 0,
                endRadius: 380
            )

            RadialGradient(
                colors: [
                    Color(red: 0.75, green: 0.78, blue: 1.0).opacity(0.45),
                    Color.clear
                ],
                center: UnitPoint(x: 0.10, y: 0.92),
                startRadius: 0,
                endRadius: 380
            )
        }
    }
}
