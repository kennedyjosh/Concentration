//
//  ViewController.swift
//  Concentration1
//
//  Created by Josh on 3/27/18.
//  Copyright © 2018 Josh Kennedy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBasedOnTheme()
        updateViewFromModel()
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int { return (cardButtons.count + 1) / 2 }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    private var emoji = [Card:String]()
    
    private var themeArray = [
        Theme(emojis:"🦇😱🙀😈🎃👻🍭🍬🍎",bgColor:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),cardColor:#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        Theme(emojis:"⚽️🏀🏈⚾️🎾🏒🏓🥊🏑",bgColor:#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1),cardColor:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)),
        Theme(emojis:"🍓🥐🥨🧀🍔🍌🍩🌽🥕",bgColor:#colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1),cardColor:#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1), textColor: #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)),
        Theme(emojis:"⛄️❄️🏂⛷🧤🏒⛸☕️🛷",bgColor:#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),cardColor:#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), textColor: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),
        Theme(emojis:"🌕🌖🌗🌘🌑🌒🌓🌔",bgColor:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),cardColor:#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        Theme(emojis:"😀😛😎🙄😰😡😂😙😔",bgColor:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),cardColor:#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        Theme(emojis:"🉐㊙️㊗️🈵🈹🈲🈴🈷️🈺🈸🈚️🈶",bgColor:#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1),cardColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), textColor:#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1))
    ]
    
    private lazy var themeIdentifier = themeArray.count.arc4random
    
    private var theme: Theme {
        get {
            return themeArray[themeIdentifier]
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.layer.cornerRadius = 5.0
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for:card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : theme.cardColor
            }
        }
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
        newGameButton.layer.cornerRadius = 5.0
    }
    
    private func updateBasedOnTheme() {
        view.backgroundColor = theme.bgColor
        for label in [flipCountLabel, scoreLabel] {
            label!.textColor = theme.cardColor
        }
        newGameButton.backgroundColor = theme.cardColor
        newGameButton.setTitleColor(theme.textColor, for: UIControlState.normal)
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil {
            let emojiChoices = theme.emojis
            if emojiChoices.count > 0 {
                let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
                emoji[card] = String(themeArray[themeIdentifier].remove(at: randomStringIndex))
            }
        }
        return emoji[card] ?? "?"
    }
    
    @IBAction private func createNewGame(_ sender: UIButton) {
        themeArray[themeIdentifier].restoreEmojis()
        themeIdentifier = themeArray.count.arc4random
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        updateBasedOnTheme()
        updateViewFromModel()
    }
    
}


extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}



