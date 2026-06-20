//
//  Counters.swift
//  reward-jar
//

import SwiftUI

struct CounterRow: View {
    let starCount: Int
    let gemCount: Int

    var body: some View {
        HStack(spacing: 20) {
            CounterChip(kind: .star, count: starCount)
            CounterChip(kind: .gem, count: gemCount)
        }
    }
}

struct CounterChip: View {
    let kind: JarItem.Kind
    let count: Int

    private var tint: Color {
        kind == .star ? Palette.starTint : Palette.gemTint
    }

    var body: some View {
        HStack(spacing: 8) {
            CartoonItem(kind: kind)
                .frame(width: 38, height: 38)
            Text("\(count)")
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(tint)
                .contentTransition(.numericText())
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(.white.opacity(0.9), in: Capsule())
        .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
    }
}
