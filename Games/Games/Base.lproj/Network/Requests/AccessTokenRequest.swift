//
//  AccessTokenRequest.swift
//  Games
//
//  Created by Vinicius on 23/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

class AccessTokenRequest: Requestable {
    
    func request(completion: @escaping (AccessToken?, CustomError?) -> Void) {
        
        var urlComponents = URLComponents(string: BaseAPI(token: true).base)
        urlComponents?.queryItems = [URLQueryItem(name: "client_id", value: BaseAPI.client_id),
                                     URLQueryItem(name: "client_secret", value: BaseAPI.client_secret),
                                     URLQueryItem(name: "grant_type", value: "client_credentials")]
        
        guard let url = urlComponents?.url else {
            completion(nil, CustomError())
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let result = data <--> (AccessToken.self, error)
            completion(result.model, result.error)
            }.resume()
    }
}
