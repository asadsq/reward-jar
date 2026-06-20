//
//  JarItem.swift
//  reward-jar
//

import Foundation

struct JarItem: Identifiable {
    let id = UUID()
    let kind: Kind
    let tilt: Double
    let xJitter: CGFloat
    let yJitter: CGFloat

    init(kind: Kind) {
        self.kind = kind
        self.tilt = Double.random(in: -18...18)
        self.xJitter = CGFloat.random(in: -4...4)
        self.yJitter = CGFloat.random(in: -3...3)
    }

    enum Kind {
        case star, gem
        var value: Int { self == .gem ? 2 : 1 }
    }
}
