//
//  CartoonItem.swift
//  reward-jar
//
//  Description:
//  Turns the plain star and gem outlines into finished, good-looking icons. It
//  stacks a drop shadow, the colored fill, a bottom shading, an outline, and a
//  bright shine highlight so each item looks glossy and three-dimensional. This
//  is the reusable icon shown in the buttons, counters, and inside the jar.
//

import SwiftUI

struct CartoonItem: View {
    let kind: JarItem.Kind

    var body: some View {
        Group {
            if kind == .star {
                CartoonStarView()
            } else {
                CartoonGemView()
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct CartoonStarView: View {
    private let bottomShade = LinearGradient(
        colors: [Color.black.opacity(0.0), Color.black.opacity(0.30)],
        startPoint: UnitPoint(x: 0.5, y: 0.4),
        endPoint: .bottom
    )
    private let shineGradient = LinearGradient(
        colors: [Color.white.opacity(0.95), Color.white.opacity(0.15)],
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        GeometryReader { geo in
            ZStack {
                CartoonStarShape()
                    .fill(Color.black.opacity(0.22))
                    .blur(radius: 3)
                    .offset(y: 4)

                CartoonStarShape()
                    .fill(Palette.starFill)

                CartoonStarShape()
                    .fill(bottomShade)

                CartoonStarShape()
                    .stroke(Palette.starStroke, lineWidth: 3)

                StarShine(insetAmount: geo.size.width * 0.30)
                    .fill(shineGradient)
                    .offset(x: -geo.size.width * 0.06, y: -geo.size.height * 0.08)
            }
        }
    }
}

struct CartoonGemView: View {
    private let bottomShade = LinearGradient(
        colors: [Color.black.opacity(0.0), Color.black.opacity(0.30)],
        startPoint: UnitPoint(x: 0.5, y: 0.45),
        endPoint: .bottom
    )
    private let shineGradient = LinearGradient(
        colors: [Color.white.opacity(0.95), Color.white.opacity(0.40)],
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        GeometryReader { _ in
            ZStack {
                CartoonGemShape()
                    .fill(Color.black.opacity(0.22))
                    .blur(radius: 3)
                    .offset(y: 4)

                CartoonGemShape()
                    .fill(Palette.gemFill)

                CartoonGemShape()
                    .fill(bottomShade)

                CartoonGemShape()
                    .stroke(Palette.gemStroke, lineWidth: 3)

                GemShine()
                    .fill(shineGradient)
            }
        }
    }
}
