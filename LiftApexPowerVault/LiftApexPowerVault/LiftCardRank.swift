//
//  CardRank.swift
//  LiftApexPowerVault
//
//  Created by LiftApexPowerVault on 2024/11/13.
//

import Foundation

enum LiftCardRank: Int, CaseIterable {
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack = 11, queen, king

    var isFaceCard: Bool {
        return self == .jack || self == .queen || self == .king
    }
}
