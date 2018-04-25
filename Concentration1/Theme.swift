//
//  Theme.swift
//  Concentration1
//
//  Created by Josh on 3/27/18.
//  Copyright © 2018 Josh Kennedy. All rights reserved.
//

import UIKit

struct Theme {
    
    var emojis: String
    var bgColor: UIColor
    var cardColor: UIColor
    var textColor : UIColor
    private var disCardedEmojis: String?
    
    init(emojis: String, bgColor: UIColor, cardColor: UIColor, textColor: UIColor) {
        self.emojis = emojis
        self.bgColor = bgColor
        self.cardColor = cardColor
        self.textColor = textColor
    }
    
    mutating func remove(at char: String.Index) -> String {
        let removedChar = String(emojis.remove(at: char))
        // add char to the discardedEmojis list for later
        if disCardedEmojis != nil {
            disCardedEmojis! += removedChar
        } else {
            disCardedEmojis = removedChar
        }
        return removedChar
    }
    
    mutating func restoreEmojis() {
        emojis += disCardedEmojis ?? ""
        disCardedEmojis = nil
    }

}
