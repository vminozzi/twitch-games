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
        
        do {
            let tokenDecoded = try JSONDecoder().decode(AccessToken.self, from: data)
            print(tokenDecoded)
        } catch let error {
            print(error.localizedDescription)
        }
        
        guard let tokenDecoded = try? JSONDecoder().decode(AccessToken.self, from: data) else {
            return nil
        }
        access_token = tokenDecoded.access_token
    }
}
