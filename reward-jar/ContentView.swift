//
//  ContentView.swift
//  reward-jar
//
//  Created by Asad Saleem Qureshi on 6/17/26.
//

import SwiftUI

struct ContentView: View {
    @State private var items: [JarItem] = []
    @State private var celebrating = false

    private let capacity = 10

    private var totalStars: Int { items.reduce(0) { $0 + $1.kind.value } }
    private var starCount: Int { items.filter { $0.kind == .star }.count }
    private var gemCount: Int { items.filter { $0.kind == .gem }.count }
    private var isNearlyFull: Bool { totalStars >= 8 && totalStars < capacity }
    private var isFull: Bool { totalStars >= capacity }

    var body: some View {
        ZStack {
            ModernBackground().ignoresSafeArea()

            VStack(spacing: 20) {
                CounterRow(starCount: starCount, gemCount: gemCount)
                    .padding(.top, 16)

                Spacer(minLength: 0)

                wobblingJar
                    .frame(width: 220, height: 250)

                Spacer(minLength: 0)

                HStack(spacing: 32) {
                    BigButton(kind: .star) {
                        SoundManager.shared.playStar()
                        addItem(.star)
                    }
                    BigButton(kind: .gem) {
                        SoundManager.shared.playGem()
                        addItem(.gem)
                    }
                }
                .padding(.bottom, 40)
                .disabled(celebrating)
            }

            if celebrating {
                CelebrationView(onDismiss: dismissCelebration)
                    .transition(.opacity)
            }
        }
        .onChange(of: isNearlyFull) { _, newValue in
            if newValue {
                SoundManager.shared.playVibration()
            }
        }
    }

    @ViewBuilder
    private var wobblingJar: some View {
        TimelineView(.animation(paused: !isNearlyFull)) { ctx in
            let t = ctx.date.timeIntervalSinceReferenceDate
            let active = isNearlyFull
            let bodyAngle = active ? sin(t * 22) * 1.8 : 0
            let lidAngle = active ? sin(t * 22 + 0.7) * 3.5 : 0
            let lidLift = active ? abs(sin(t * 22 + 0.7)) * 2.0 : 0

            Jar(items: items, lidAngle: lidAngle, lidLift: lidLift)
                .frame(width: 220, height: 250)
                .rotationEffect(.degrees(bodyAngle))
        }
    }

    private func addItem(_ kind: JarItem.Kind) {
        guard !isFull else { return }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        withAnimation(.spring(response: 0.45, dampingFraction: 0.65)) {
            items.append(JarItem(kind: kind))
        }

        if totalStars >= capacity {
            triggerCelebration()
        }
    }

    private func triggerCelebration() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        SoundManager.shared.playExplosion()
        withAnimation(.easeIn(duration: 0.25)) {
            celebrating = true
        }
    }

    private func dismissCelebration() {
        withAnimation(.easeOut(duration: 0.5)) {
            items.removeAll()
            celebrating = false
        }
    }
}

#Preview {
    ContentView()
}
