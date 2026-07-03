//
//  Celebration.swift
//  reward-jar
//
//  Description:
//  The full-screen "you did it!" celebration that appears once the jar is full.
//  It dims the screen, bursts emoji confetti outward, and pops up a reward panel
//  with a trophy. Tapping anywhere dismisses it, which empties the jar to start
//  over.
//

import SwiftUI

struct CelebrationView: View {
    let onDismiss: () -> Void
    @State private var explode = false
    @State private var fade = false
    @State private var panelIn = false
    @State private var showHint = false
    private let particles: [Particle] = (0..<20).map { _ in Particle.random() }

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()

            ForEach(particles) { p in
                Text(p.emoji)
                    .font(.system(size: p.size))
                    .offset(
                        x: explode ? p.endOffset.width : 0,
                        y: explode ? p.endOffset.height : 0
                    )
                    .rotationEffect(.degrees(explode ? p.rotation : 0))
                    .opacity(fade ? 0 : 1)
            }

            VStack {
                Spacer()
                RewardPanel()
                    .scaleEffect(panelIn ? 1.0 : 0.55)
                    .opacity(panelIn ? 1 : 0)
                Spacer()
                Text("tap anywhere to continue")
                    .font(.system(size: 14, weight: .medium))
                    .tracking(1.5)
                    .foregroundStyle(.white.opacity(0.75))
                    .padding(.bottom, 44)
                    .opacity(showHint ? 1 : 0)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { onDismiss() }
        .onAppear {
            withAnimation(.easeOut(duration: 5.0)) {
                explode = true
            }
            withAnimation(.easeIn(duration: 2.0).delay(10.0)) {
                fade = true
            }
            withAnimation(.spring(response: 0.55, dampingFraction: 0.65)) {
                panelIn = true
            }
            withAnimation(.easeIn(duration: 0.6).delay(4.0)) {
                showHint = true
            }
        }
    }
}

struct RewardPanel: View {
    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.82, blue: 0.45),
                                Color(red: 0.95, green: 0.55, blue: 0.18)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 78, height: 78)
                    .shadow(color: Color(red: 1.0, green: 0.65, blue: 0.2).opacity(0.6),
                            radius: 18, y: 6)
                Image(systemName: "trophy.fill")
                    .font(.system(size: 38, weight: .medium))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 6) {
                Text("Reward Earned")
                    .font(.system(size: 32, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(.white)
                Text("YOU DID IT")
                    .font(.system(size: 12, weight: .semibold))
                    .tracking(4)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 48)
        .padding(.vertical, 32)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [.white.opacity(0.7), .white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: Color(red: 0.6, green: 0.2, blue: 0.5).opacity(0.45),
                radius: 32, y: 14)
    }
}

struct Particle: Identifiable {
    let id = UUID()
    let emoji: String
    let size: CGFloat
    let endOffset: CGSize
    let rotation: Double

    static func random() -> Particle {
        let emojis = ["⭐", "💎", "✨", "🎉", "🌟", "🎊"]
        let angle = Double.random(in: 0..<(2 * .pi))
        let distance = CGFloat.random(in: 220...430)
        return Particle(
            emoji: emojis.randomElement()!,
            size: CGFloat.random(in: 32...54),
            endOffset: CGSize(
                width: cos(angle) * distance,
                height: sin(angle) * distance
            ),
            rotation: Double.random(in: -600...600)
        )
    }
}
