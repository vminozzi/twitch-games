//
//  HomeViewModel.swift
//  Games
//
//  Created by Vinicius on 24/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import CoreData

struct GameDTO {
    var id = 0
    var name = ""
    var image: UIImage?
    var identifier = ""
    var favorite = false
}

protocol LoadContent: class {
    func feedback(error: String?)
    func didLoadImage(identifier: String)
}

protocol HomeViewModelDelegate: class {
    
    var canLoad: Bool { get }
    
    func getGames()
    func refresh()
    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func getGameDTO(at row: Int) -> GameDTO
    func getGameDetailDTO(at row: Int) -> GameDetailDTO 
    func getImage(at row: Int) -> UIImage?
    func imageFromCache(identifier: String) -> UIImage?
    func sizeForItems(with width: CGFloat, height: CGFloat) -> CGSize
    func didFavorite(with id: Int, shouldFavorite: Bool, imageData: Data?)
}

class HomeViewModel: HomeViewModelDelegate {
    
    var games = [Game]()
    var canLoad = true
    private var cache = NSCache<NSString, UIImage>()
    private var favorites = [Game]()
    private var token = ""
    private weak var loadContentDelegate: LoadContent?
    
    init(delegate: LoadContent) {
        self.loadContentDelegate = delegate
        loadContent()
        loadFavorites()
    }
    
    init() { }
    
    private func loadContent() {
        if token.isEmpty {
            AccessTokenRequest().request(completion: { accessToken, error in
                if error == nil {
                    self.token = accessToken?.access_token ?? ""
                    self.getGames()
                } else {
                    if self.games.count == 0 {
                        self.favorites.forEach { self.games.append($0) }
                    }
                    self.canLoad = false
                    self.loadContentDelegate?.feedback(error: error?.message)
                }
            })
        } else {
            getGames()
        }
    }
    
    func refresh() {
        games = [Game]()
        canLoad = true
        loadFavorites()
        getGames()
    }
    
    func getGames() {
        if canLoad {
            GameRequest(accessToken: token, offset: games.count).request { gameResult, error in
                gameResult?.top.forEach { self.games.append($0) }
                self.canLoad = gameResult?.total != self.games.count
                
                if (gameResult?.top.count == 0 || gameResult?.top == nil) && self.games.count == 0 && self.favorites.count > 0 {
                    self.favorites.forEach { self.games.append($0) }
                    self.canLoad = false
                }
                self.loadContentDelegate?.feedback(error: error?.message)
            }
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems() -> Int {
        return games.count
    }
    
    func getGameDTO(at row: Int) -> GameDTO {
        return GameDTO(id: games.object(index: row)?.game?._id ?? 0,
                       name: games.object(index: row)?.game?.name ?? "",
                       image: getImage(at: row),
                       identifier: games.object(index: row)?.game?.box?.large ?? "",
                       favorite: isFavorite(id: games.object(index: row)?.game?._id ?? 0))
    }
    
    func getGameDetailDTO(at row: Int) -> GameDetailDTO {
        return GameDetailDTO(name: games.object(index: row)?.game?.name ?? "",
                             image: games.object(index: row)?.game?.box?.template ?? "",
                             views: games.object(index: row)?.viewers ?? 0,
                             channels: games.object(index: row)?.channels ?? 0)
    }
    
    func sizeForItems(with width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: ((width / 2) - 12), height: ((height / 2) - 12))
    }
    
    func getImage(at row: Int) -> UIImage? {
        if let imageData = games.object(index: row)?.game?.box?.imageData, let image = UIImage(data: imageData) {
            return image
        }
        
        let imageString = games.object(index: row)?.game?.box?.large ?? ""
        if let imageCached = cache.object(forKey: NSString(string: imageString)) {
            return imageCached
        }
        
        let placeholder = UIImage(named: "placeholder-icon")
        placeholder?.accessibilityIdentifier = "placeholder"
        cache.setObject(placeholder ?? UIImage(), forKey: NSString(string: imageString))
        
        if let url = URL(string: imageString) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: NSString(string: imageString))
                        self.loadContentDelegate?.didLoadImage(identifier: imageString)
                    }
                }
            }).resume()
        }
        return nil
    }
    
    func imageFromCache(identifier: String) -> UIImage? {
        return cache.object(forKey: NSString(string: identifier))
    }
    
    func loadFavorites() {
        favorites = FavoriteManager().loadGames()
    }
    
    func isFavorite(id: Int) -> Bool {
        return favorites.filter { $0.game?._id == id }.count > 0
    }
    
    func didFavorite(with id: Int, shouldFavorite: Bool, imageData: Data?) {
        let pop = SystemSoundID(1520)
        AudioServicesPlaySystemSound(pop)
        
        let array = games.filter { id == $0.game?._id }
        guard let game = array.first else {
            return
        }
        
        var favorite = game
        favorite.game?.box?.imageData = imageData
        if shouldFavorite {
            FavoriteManager.save(favorite: favorite)
        } else {
            FavoriteManager.remove(favorite: favorite)
        }
    }
}
