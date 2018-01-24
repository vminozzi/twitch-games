//
//  GameModel.swift
//  Games
//
//  Created by Vinicius on 24/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct GameModel: Mappable {
    
    var name = ""
    var popularity = 0
    var _id = 0
    var giantbomb_id = 0
    var locale = ""
    var box: GameBoxImage?
    
    init?(data: Data) {
        
    }
    
    static func == (lhs: GameModel, rhs: GameModel) -> Bool {
        return lhs.name == rhs.name && lhs.popularity == rhs.popularity && lhs._id == rhs._id && lhs.giantbomb_id == rhs.giantbomb_id && lhs.locale == rhs.locale && lhs.box == rhs.box
    }
}
