//
//  ElevensGame.swift
//  LiftApexPowerVault
//
//  Created by LiftApexPowerVault on 2024/11/13.
//

import Foundation

class LiftElevensGame {
    private var deck: [LiftCard] = []
    private(set) var board: [LiftCard] = []
    let boardSize = 9 // 3x3 grid for simplicity

    init() {
        deck = LiftCard.createDeck()
        dealCards()
    }

    func dealCards() {
        board = Array(deck.prefix(boardSize))
        deck.removeFirst(boardSize)
    }

    func isPairAddingToEleven(_ card1: LiftCard, _ card2: LiftCard) -> Bool {
        return card1.value + card2.value == 11
    }

    func isFaceCardSet(_ cards: [LiftCard]) -> Bool {
        guard cards.count == 3 else { return false }
        let ranks = cards.map { $0.rank }
        return ranks.contains(.jack) && ranks.contains(.queen) && ranks.contains(.king)
    }

    func removeCards(_ cards: [LiftCard]) {
        board.removeAll { card in
            cards.contains(where: { $0 == card })
        }
        fillEmptySpaces()
    }

    private func fillEmptySpaces() {
        let emptySpaces = boardSize - board.count
        let newCards = Array(deck.prefix(emptySpaces))
        board.append(contentsOf: newCards)
        deck.removeFirst(emptySpaces)
    }
    
    func hasMovesAvailable() -> Bool {
        for i in 0..<board.count {
            for j in i+1..<board.count {
                if isPairAddingToEleven(board[i], board[j]) {
                    return true
                }
            }
        }
        let faceCards = board.filter { $0.isFaceCard }
        return faceCards.count >= 3
    }
}
