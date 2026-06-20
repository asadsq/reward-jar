//
//  Jar.swift
//  reward-jar
//

import SwiftUI

struct Jar: View {
    let items: [JarItem]
    let lidAngle: Double
    let lidLift: CGFloat

    var body: some View {
        GeometryReader { geo in
            let lidH = geo.size.height * 0.13
            let bodyTop = lidH * 0.55

            ZStack(alignment: .top) {
                JarBody()
                    .padding(.top, bodyTop)

                ItemPile(items: items, size: geo.size, bodyTop: bodyTop)

                JarLid()
                    .frame(height: lidH)
                    .rotationEffect(.degrees(lidAngle), anchor: .bottom)
                    .offset(y: -lidLift)
            }
        }
    }
}

struct JarBody: View {
    var body: some View {
        ZStack {
            JarBodyShape()
                .fill(Palette.glassFill)
            JarHighlight()
                .fill(Color.white.opacity(0.55))
                .blur(radius: 1.2)
            JarTopReflection()
                .fill(Color.white.opacity(0.45))
                .blur(radius: 0.8)
            JarBodyShape()
                .stroke(Palette.glassStroke, lineWidth: 4)
        }
    }
}

struct JarLid: View {
    var body: some View {
        ZStack {
            JarLidShape()
                .fill(Palette.lidFill)
            JarLidShape()
                .stroke(Palette.lidStroke, lineWidth: 3)
        }
        .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
    }
}

struct JarBodyShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let neckInset = w * 0.12
        let cornerR: CGFloat = 24

        path.move(to: CGPoint(x: neckInset, y: 0))
        path.addLine(to: CGPoint(x: w - neckInset, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: w, y: h * 0.22),
            control: CGPoint(x: w, y: h * 0.04)
        )
        path.addLine(to: CGPoint(x: w, y: h - cornerR))
        path.addQuadCurve(
            to: CGPoint(x: w - cornerR, y: h),
            control: CGPoint(x: w, y: h)
        )
        path.addLine(to: CGPoint(x: cornerR, y: h))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: h - cornerR),
            control: CGPoint(x: 0, y: h)
        )
        path.addLine(to: CGPoint(x: 0, y: h * 0.22))
        path.addQuadCurve(
            to: CGPoint(x: neckInset, y: 0),
            control: CGPoint(x: 0, y: h * 0.04)
        )
        path.closeSubpath()
        return path
    }
}

struct JarLidShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let lidW = w * 0.74
        let lidX = (w - lidW) / 2

        path.addRoundedRect(
            in: CGRect(x: lidX, y: h * 0.18, width: lidW, height: h * 0.82),
            cornerSize: CGSize(width: h * 0.35, height: h * 0.35)
        )
        let knobW = lidW * 0.45
        let knobX = (w - knobW) / 2
        path.addRoundedRect(
            in: CGRect(x: knobX, y: 0, width: knobW, height: h * 0.32),
            cornerSize: CGSize(width: h * 0.16, height: h * 0.16)
        )
        return path
    }
}

struct JarHighlight: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let x1: CGFloat = w * 0.10
        let x2: CGFloat = w * 0.18
        let y1: CGFloat = h * 0.18
        let y2: CGFloat = h * 0.78

        path.move(to: CGPoint(x: x1, y: y1))
        path.addQuadCurve(
            to: CGPoint(x: x1 - 5, y: y2),
            control: CGPoint(x: x1 - 10, y: (y1 + y2) / 2)
        )
        path.addLine(to: CGPoint(x: x2 - 5, y: y2))
        path.addQuadCurve(
            to: CGPoint(x: x2, y: y1),
            control: CGPoint(x: x2 + 5, y: (y1 + y2) / 2)
        )
        path.closeSubpath()
        return path
    }
}

struct JarTopReflection: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let leftX = w * 0.30
        let rightX = w * 0.60
        let topY = h * 0.06
        let botY = h * 0.12

        path.move(to: CGPoint(x: leftX, y: topY))
        path.addQuadCurve(
            to: CGPoint(x: rightX, y: topY),
            control: CGPoint(x: (leftX + rightX) / 2, y: topY - 4)
        )
        path.addLine(to: CGPoint(x: rightX - 6, y: botY))
        path.addQuadCurve(
            to: CGPoint(x: leftX + 6, y: botY),
            control: CGPoint(x: (leftX + rightX) / 2, y: botY - 2)
        )
        path.closeSubpath()
        return path
    }
}

struct ItemPile: View {
    let items: [JarItem]
    let size: CGSize
    let bodyTop: CGFloat

    private let perRow = 3
    private let itemSize: CGFloat = 72
    private let xSpacing: CGFloat = 52
    private let ySpacing: CGFloat = 30

    var body: some View {
        ZStack {
            ForEach(Array(items.enumerated()), id: \.element.id) { idx, item in
                CartoonItem(kind: item.kind)
                    .frame(width: itemSize, height: itemSize)
                    .rotationEffect(.degrees(item.tilt))
                    .position(position(for: idx, item: item))
                    .transition(
                        .asymmetric(
                            insertion: .scale(scale: 0.2)
                                .combined(with: .opacity)
                                .combined(with: .offset(y: -80)),
                            removal: .scale(scale: 0.4).combined(with: .opacity)
                        )
                    )
            }
        }
    }

    private func position(for index: Int, item: JarItem) -> CGPoint {
        let row = index / perRow
        let col = index % perRow
        let staggerX: CGFloat = (row % 2 == 0) ? 0 : 14
        let baseY = size.height - 50
        let centerX = size.width / 2
        let x = centerX + CGFloat(col - 1) * xSpacing + staggerX + item.xJitter
        let y = baseY - CGFloat(row) * ySpacing + item.yJitter
        return CGPoint(x: x, y: y)
    }
}
