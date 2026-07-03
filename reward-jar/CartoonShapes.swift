//
//  CartoonShapes.swift
//  reward-jar
//
//  Description:
//  The raw outlines used to draw a star and a gem, plus the smaller "shine"
//  shapes that go on top of them for a glossy look. These are just the vector
//  paths (the geometry); the coloring and shading happen in CartoonItem.swift.
//

import SwiftUI

struct CartoonStarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outer = min(rect.width, rect.height) / 2
        let inner = outer * 0.45
        var path = Path()
        for i in 0..<10 {
            let angle = Double(i) * .pi / 5 - .pi / 2
            let r = i.isMultiple(of: 2) ? outer : inner
            let pt = CGPoint(
                x: center.x + CGFloat(cos(angle)) * r,
                y: center.y + CGFloat(sin(angle)) * r
            )
            if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
        }
        path.closeSubpath()
        return path
    }
}

struct CartoonGemShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: w * 0.28, y: h * 0.25))
        path.addLine(to: CGPoint(x: w * 0.72, y: h * 0.25))
        path.addLine(to: CGPoint(x: w * 0.97, y: h * 0.45))
        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.97))
        path.addLine(to: CGPoint(x: w * 0.03, y: h * 0.45))
        path.closeSubpath()
        return path
    }
}

struct StarShine: Shape {
    let insetAmount: CGFloat

    func path(in rect: CGRect) -> Path {
        let inner = rect.insetBy(dx: insetAmount, dy: insetAmount)
        return CartoonStarShape().path(in: inner)
    }
}

struct GemShine: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.width * 0.33, y: rect.height * 0.32))
        p.addLine(to: CGPoint(x: rect.width * 0.55, y: rect.height * 0.32))
        p.addLine(to: CGPoint(x: rect.width * 0.42, y: rect.height * 0.55))
        p.closeSubpath()
        return p
    }
}
