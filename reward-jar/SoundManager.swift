//
//  SoundManager.swift
//  reward-jar
//

import AVFoundation

final class SoundManager {
    static let shared = SoundManager()

    private let engine = AVAudioEngine()
    private let audioFormat: AVAudioFormat?
    private var players: [AVAudioPlayerNode] = []
    private var nextPlayerIndex = 0
    private let sampleRate: Double = 44100
    private var buffers: [String: AVAudioPCMBuffer] = [:]
    private var ready = false

    private init() {
        audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)
        guard let format = audioFormat else { return }

        configureSession()

        // Pre-attach and connect a pool of player nodes BEFORE starting.
        // The engine needs at least one connected node or start() will trap.
        for _ in 0..<4 {
            let p = AVAudioPlayerNode()
            engine.attach(p)
            engine.connect(p, to: engine.mainMixerNode, format: format)
            players.append(p)
        }

        prepareBuffers()

        do {
            try engine.start()
            ready = true
        } catch {
            ready = false
        }
    }

    private func configureSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .ambient, mode: .default, options: [.mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Best-effort; sounds will silently fail if this throws.
        }
    }

    private func prepareBuffers() {
        buffers["star"] = makeMelody(
            notes: [(1320, 0.08), (1760, 0.16)],
            envelope: .pluck
        )
        buffers["gem"] = makeChord(
            frequencies: [523.25, 659.25, 987.77],
            duration: 0.45,
            envelope: .chime
        )
        buffers["vibration"] = makeBuzz(frequency: 90, duration: 0.30)
        buffers["explosion"] = makeExplosion(duration: 0.8)
    }

    func playStar() { play("star") }
    func playGem() { play("gem") }
    func playVibration() { play("vibration") }
    func playExplosion() { play("explosion") }

    private func play(_ name: String) {
        guard ready, !players.isEmpty, let buffer = buffers[name] else { return }
        let player = players[nextPlayerIndex]
        nextPlayerIndex = (nextPlayerIndex + 1) % players.count

        if player.isPlaying { player.stop() }
        player.scheduleBuffer(buffer, at: nil, completionHandler: nil)
        player.play()
    }

    // MARK: Synthesis

    private enum Envelope { case pluck, chime, buzz, sparkle }

    private func makeBuffer(frames: Int) -> AVAudioPCMBuffer? {
        guard let format = AVAudioFormat(
            standardFormatWithSampleRate: sampleRate, channels: 1
        ),
        let buffer = AVAudioPCMBuffer(
            pcmFormat: format, frameCapacity: AVAudioFrameCount(frames)
        ) else { return nil }
        buffer.frameLength = AVAudioFrameCount(frames)
        return buffer
    }

    private func envelopeValue(t: Double, total: Double, type: Envelope) -> Double {
        switch type {
        case .pluck:
            let attack = 0.005
            if t < attack { return t / attack }
            return exp(-(t - attack) * 8)
        case .chime:
            let attack = 0.01
            if t < attack { return t / attack }
            return exp(-(t - attack) * 3.5)
        case .buzz:
            let release = 0.04
            let fadeIn = min(1.0, t / 0.005)
            let fadeOut = min(1.0, max(0, (total - t) / release))
            return fadeIn * fadeOut * 0.9
        case .sparkle:
            let attack = total * 0.05
            if t < attack { return t / attack }
            let progress = (t - attack) / (total - attack)
            return max(0, 1.0 - progress)
        }
    }

    private func makeMelody(
        notes: [(Double, Double)],
        envelope: Envelope
    ) -> AVAudioPCMBuffer? {
        let total = notes.reduce(0) { $0 + $1.1 }
        let frames = Int(sampleRate * total)
        guard let buffer = makeBuffer(frames: frames) else { return nil }

        var cursor = 0
        for (freq, dur) in notes {
            let noteFrames = Int(sampleRate * dur)
            let theta = 2.0 * Double.pi * freq / sampleRate
            for i in 0..<noteFrames where cursor + i < frames {
                let t = Double(i) / sampleRate
                let env = envelopeValue(t: t, total: dur, type: envelope)
                let sample = Float(sin(theta * Double(i)) * env * 0.32)
                buffer.floatChannelData?[0][cursor + i] = sample
            }
            cursor += noteFrames
        }
        return buffer
    }

    private func makeChord(
        frequencies: [Double],
        duration: Double,
        envelope: Envelope
    ) -> AVAudioPCMBuffer? {
        let frames = Int(sampleRate * duration)
        guard let buffer = makeBuffer(frames: frames) else { return nil }

        let count = Double(frequencies.count)
        for frame in 0..<frames {
            let t = Double(frame) / sampleRate
            let env = envelopeValue(t: t, total: duration, type: envelope)
            var s: Double = 0
            for freq in frequencies {
                s += sin(2.0 * Double.pi * freq * t)
            }
            buffer.floatChannelData?[0][frame] = Float((s / count) * env * 0.35)
        }
        return buffer
    }

    private func makeBuzz(frequency: Double, duration: Double) -> AVAudioPCMBuffer? {
        let frames = Int(sampleRate * duration)
        guard let buffer = makeBuffer(frames: frames) else { return nil }

        let theta = 2.0 * Double.pi * frequency / sampleRate
        for frame in 0..<frames {
            let t = Double(frame) / sampleRate
            let env = envelopeValue(t: t, total: duration, type: .buzz)
            let raw = sin(theta * Double(frame))
            let shaped = max(-0.7, min(0.7, raw * 1.8))
            buffer.floatChannelData?[0][frame] = Float(shaped * env * 0.32)
        }
        return buffer
    }

    private func makeExplosion(duration: Double) -> AVAudioPCMBuffer? {
        let frames = Int(sampleRate * duration)
        guard let buffer = makeBuffer(frames: frames) else { return nil }

        var phase: Double = 0
        for frame in 0..<frames {
            let t = Double(frame) / sampleRate
            let progress = t / duration
            let freq = 200.0 + (1600.0 * progress)
            phase += 2.0 * Double.pi * freq / sampleRate
            let thump = sin(2.0 * Double.pi * 80 * t) * exp(-t * 12)
            let env = envelopeValue(t: t, total: duration, type: .sparkle)
            let sparkle = sin(phase) * env
            let s = thump * 0.5 + sparkle * 0.4
            buffer.floatChannelData?[0][frame] = Float(s * 0.4)
        }
        return buffer
    }
}
