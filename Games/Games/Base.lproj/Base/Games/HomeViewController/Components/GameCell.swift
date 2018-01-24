//
//  GameCell.swift
//  Games
//
//  Created by Vinicius on 24/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import UIKit

protocol GameCellDelegate: class {
    func didFavorite(with id: Int, shouldFavorite: Bool)
}

class GameCell: UICollectionViewCell {
    
    weak var delegate: GameCellDelegate?
    var identifier: String?
    private var id = 0
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(with dto: GameDTO?) {
        guard let data = dto else {
            return
        }
        name.text = data.name
        identifier = data.identifier
        id = data.id
        setImage(with: data.image)
        setImage(favorite: data.favorite)
    }
    
    func setImage(with image: UIImage?) {
        poster.image = image
    }
    
    private func setImage(favorite: Bool) {
        favoriteButton.isSelected = favorite
    }
    
    @IBAction func favorite(_ sender: UIButton) {
        delegate?.didFavorite(with: id, shouldFavorite: !sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
}
