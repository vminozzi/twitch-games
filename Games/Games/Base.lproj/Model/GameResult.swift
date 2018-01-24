//
//  File.swift
//  Games
//
//  Created by Vinicius on 24/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct GameResult: Mappable {
    
    var top = [Game]()
    var total: Int?
    
    init?(data: Data) {
        guard let gameDecoded = try? JSONDecoder().decode(GameResult.self, from: data) else {
            return nil
        }
        top = gameDecoded.top
        total = gameDecoded.total
    }
    
    static func == (lhs: GameResult, rhs: GameResult) -> Bool {
        return lhs.top == rhs.top && lhs.total == rhs.total
    }
}
