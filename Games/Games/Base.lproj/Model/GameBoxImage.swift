//
//  GameBoxImage.swift
//  Games
//
//  Created by Vinicius on 24/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct GameBoxImage: Mappable {
    
    var large = ""
    var template = ""
    
    init?(data: Data) {
        
    }
    
    static func == (lhs: GameBoxImage, rhs: GameBoxImage) -> Bool {
        return lhs.large == rhs.large && lhs.template == rhs.template
    }
}
