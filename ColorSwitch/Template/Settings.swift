//
//  Settings.swift
//  ColorSwitch
//
//  Created by Gabriel Jesus Santos on 17/05/21.
//

import SpriteKit

enum PhysicsCategories {
    static let none: UInt32 = 0
    static let ballCategory: UInt32 = 0x1                                     // 01
    static let switchCategory: UInt32 = 0x1 << 1 // << Bitwise shift operator // 10
}

// Definir o zPosition faz com que consigamos controlar a ordem de exibição, quem deve aparecer na frente de quem
enum ZPositions {
    static let label: CGFloat = 0
    static let ball: CGFloat = 1
    static let colorSwitch: CGFloat = 2
}
