//
//  Card.swift
//  LiftApexPowerVault
//
//  Created by LiftApexPowerVault on 2024/11/13.
//

import UIKit

struct LiftCard: Equatable {
    let rank: LiftCardRank
    let suit: LiftCardSuit

    var value: Int {
        return rank.rawValue
    }

    var isFaceCard: Bool {
        return rank.isFaceCard
    }

    var imageName: String {
        let rankString: String
        switch rank {
        case .jack:
            rankString = "J"
        case .queen:
            rankString = "Q"
        case .king:
            rankString = "K"
        default:
            rankString = "\(rank.rawValue)"
        }

        let suitString: String
        switch suit {
        case .hearts:
            suitString = "♥️"
        case .diamonds:
            suitString = "♦️"
        case .clubs:
            suitString = "♣️"
        case .spades:
            suitString = "♠️"
        }

        return "\(rankString)\(suitString)"
    }

    static func == (lhs: LiftCard, rhs: LiftCard) -> Bool {
        return lhs.rank == rhs.rank && lhs.suit == rhs.suit
    }

    static func createDeck() -> [LiftCard] {
        var deck = [LiftCard]()
        for suit in LiftCardSuit.allCases {
            for rank in LiftCardRank.allCases {
                deck.append(LiftCard(rank: rank, suit: suit))
            }
        }
        return deck.shuffled()
    }
}
