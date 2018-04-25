//
//  Concentration.swift
//  Concentration1
//
//  Created by Josh on 3/27/18.
//  Copyright © 2018 Josh Kennedy. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards = [Card]()
    
    private(set) var flipCount = 0
    
    private(set) var score = 0
    
    private var timeOfLastMatch = Date()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(numberOfPairsOfCards: \(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // shuffle the cards
        for index in cards.indices{
//            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            cards.swapAt(index, cards.count.arc4random)
        }
        
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            flipCount += 1
            // more than one card is facing up
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 20
                    // add to score based on time completion
                    let timeDiff = Int(Date().timeIntervalSince(timeOfLastMatch))
                    if timeDiff <= 10 {
                        score += 10 - timeDiff
                        timeOfLastMatch = Date()
                    }
                // if cards dont match
                } else {
                    if cards[index].hasBeenSeen {
                        score -= 10
                    }
                    if cards[matchIndex].hasBeenSeen {
                        score -= 10
                    }
                }
                cards[index].isFaceUp = true
                cards[index].hasBeenSeen = true
                cards[matchIndex].hasBeenSeen = true
            // either no cards or two carda are face up
            } else {
                // if card isn't already facing up
                if !cards[index].isFaceUp {
                    indexOfOneAndOnlyFaceUpCard = index
                // if card is already facing up
                } else {
                    // if no cards are facing up
                    if indexOfOneAndOnlyFaceUpCard != nil {
                        for flipDownIndex in cards.indices {
                            cards[flipDownIndex].isFaceUp = false
                        }
                        cards[index].hasBeenSeen = true
                    // if two cards are facing up
                    } else {
                        indexOfOneAndOnlyFaceUpCard = index
                        flipCount -= 1
                    }
                }
            }
        }
    }
}


extension Collection {
    // returns the only element of a list if there is only one element in a list
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
