//
//  File.swift
//  Games
//
//  Created by Vinicius on 24/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct Game: Mappable {
    
    var game: GameModel?
    var viewers: Int?
    var channels: Int?
    
    init?(data: Data) {
        
    }
    
    init() { }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.game == rhs.game && lhs.viewers == rhs.viewers && lhs.channels == rhs.channels
    }
}
