//
//  File.swift
//  Games
//
//  Created by Vinicius on 23/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct AccessToken: Mappable {
    
    var access_token = ""
    
    init?(data: Data) {
        guard let tokenDecoded = try? JSONDecoder().decode(AccessToken.self, from: data) else {
            return nil
        }
        access_token = tokenDecoded.access_token
    }
    
    static func == (lhs: AccessToken, rhs: AccessToken) -> Bool {
        return lhs.access_token == rhs.access_token
    }
}
