//
//  BaseAPI.swift
//  Games
//
//  Created by Vinicius on 23/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

protocol Mappable: Codable, Equatable {
    init?(data: Data)
}

protocol Requestable: class {
    associatedtype DataType
    func request(completion: @escaping (_ result: DataType?, _ error: CustomError?) -> Void)
}

struct BaseAPI {
    
    static var client_id = "ne6wi3sonof8qyefvn73c2s5ackduv"
    static var client_secret = "jjs8va35nmy5m21f2mflhojhu07o3l"
    
    var base = ""
    
    var games: String {
        return base + "games/top"
    }
    
    init(token: Bool) {
        base = token ? "https://api.twitch.tv/kraken/oauth2/token" : "https://api.twitch.tv/kraken/"
    }
}

precedencegroup ExponentiativePrecedence { }

infix operator <--> :ExponentiativePrecedence

func <--> <T: Mappable>(data: Data?, handle: (type: T.Type, error: Error?)) -> (model: T?, error: CustomError?) {
    
    if let error = handle.error {
        return (nil, CustomError(error: error))
    }
    
    guard let data = data, let model = T(data: data) else {
        return (nil, CustomError(error: handle.error))
    }
    
    return (model, nil)
}
