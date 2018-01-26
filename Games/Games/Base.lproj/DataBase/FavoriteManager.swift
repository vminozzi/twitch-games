//
//  FavoriteManager.swift
//  Games
//
//  Created by Vinicius on 26/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation
import CoreData

class FavoriteManager {

    class func save(favorite: Game) {
        let dataBase = LocalDataBase()
        let managedContext = dataBase.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteGame", in: managedContext)!
        let game = NSManagedObject(entity: entity, insertInto: managedContext)
        
        game.setValue(favorite.game?.name, forKey: "name")
        game.setValue(favorite.channels, forKey: "channels")
        game.setValue(favorite.viewers, forKey: "viewers")
        game.setValue(favorite.game?.popularity, forKey: "popularity")
        game.setValue(favorite.game?._id, forKey: "id")
        game.setValue(favorite.game?.giantbomb_id, forKey: "giantbomb_id")
        game.setValue(favorite.game?.locale, forKey: "locale")
        game.setValue(favorite.game?.box?.large, forKey: "large")
        game.setValue(favorite.game?.box?.template, forKey: "template")
        game.setValue(favorite.game?.box?.imageData, forKey: "imageData")
        
        try? managedContext.save()
    }
    
    func loadGames() -> [Game] {
        let dataBase = LocalDataBase()
        let managedContext = dataBase.persistentContainer.viewContext
        var favorites = [Game]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
        if let results = try? managedContext.fetch(request) as? [FavoriteGame] {
            results?.forEach { favorites.append(setFavoriteGame(with: $0)) }
        }
        return favorites
    }
    
    func setFavoriteGame(with object: FavoriteGame) -> Game {
        var favorite = Game()
        favorite.channels = Int(object.channels)
        favorite.viewers = Int(object.viewers)
        
        var game = GameModel()
        game.name = object.name ?? ""
        game._id = Int(object.id)
        game.popularity = Int(object.popularity)
        game.giantbomb_id = Int(object.giantbomb_id)
        game.locale = object.locale ?? ""
        
        var box = GameBoxImage()
        box.large = object.large ?? ""
        box.template = object.template ?? ""
        box.imageData = object.imageData
        game.box = box
        
        favorite.game = game
        
        return favorite
    }
    
    class func remove(favorite: Game) {
        let dataBase = LocalDataBase()
        let managedContext = dataBase.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
        if let results = try? managedContext.fetch(request) as? [FavoriteGame] {
            let game = results?.filter { Int($0.id) == favorite.game?._id }.first
            if let gameModel = game {
                managedContext.delete(gameModel)
                try? managedContext.save()
            }
        }
    }
}
