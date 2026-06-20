//
//  Buttons.swift
//  reward-jar
//

import SwiftUI

struct BigButton: View {
    let kind: JarItem.Kind
    let action: () -> Void

    private var colors: [Color] {
        kind == .star
            ? [Color(red: 1.0, green: 0.60, blue: 0.78),
               Color(red: 0.88, green: 0.22, blue: 0.48)]
            : [Color(red: 0.72, green: 0.52, blue: 1.0),
               Color(red: 0.40, green: 0.16, blue: 0.75)]
    }

    var body: some View {
        Button(action: action) {
            CartoonItem(kind: kind)
                .frame(width: 78, height: 78)
                .padding(24)
                .background(
                    LinearGradient(
                        colors: colors,
                        startPoint: .top, endPoint: .bottom
                    ),
                    in: Circle()
                )
                .overlay(
                    Circle()
                        .strokeBorder(.white.opacity(0.25), lineWidth: 2)
                )
                .shadow(color: colors.last?.opacity(0.55) ?? .clear,
                        radius: 14, y: 8)
        }
        .buttonStyle(BounceStyle())
    }
}

struct BounceStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.5),
                       value: configuration.isPressed)
    }
}
