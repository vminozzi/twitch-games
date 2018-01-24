//
//  File.swift
//  Games
//
//  Created by Vinicius on 24/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

class GameRequest: Requestable {
    
    private var token = ""
    private var offset = 0
    
    init(accessToken: String, offset: Int) {
        token = accessToken
        self.offset = offset
    }
    
    func request(completion: @escaping (GameResult?, CustomError?) -> Void) {
        
        var urlComponents = URLComponents(string: BaseAPI(token: false).games)
        urlComponents?.queryItems = [URLQueryItem(name: "limit", value: "20"),
                                     URLQueryItem(name: "offset", value: "\(offset)")]
        
        guard let url = urlComponents?.url else {
            completion(nil, CustomError())
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(BaseAPI.client_id, forHTTPHeaderField: "client-id")
        request.addValue(token, forHTTPHeaderField: "access-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let result = data <--> (GameResult.self, error)
            completion(result.model, result.error)
            }.resume()
    }
}
