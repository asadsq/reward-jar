//
//  JarItem.swift
//  reward-jar
//
//  Description:
//  The simple data model for one item in the jar. Each item is either a star or
//  a gem, remembers a random tilt and slight position offset so the pile looks
//  hand-placed, and knows its point value (a star is worth 1, a gem is worth 2).
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
