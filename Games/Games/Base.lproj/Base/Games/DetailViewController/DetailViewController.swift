//
//  DetailViewController.swift
//  Games
//
//  Created by Vinicius on 24/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import UIKit

struct GameDetailDTO {
    var name = ""
    var image = ""
    var views = 0
    var channels = 0
}

class DetailViewController: UITableViewController, DetailGameLoadContent {

    private lazy var viewModel: DetailGameViewModelDelegate = DetailGameViewModel(delegate: self, imageId: detailDTO.image, width: view.frame.size.width)
    private var detailDTO = GameDetailDTO()
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var channels: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func populate() {
        name.text = detailDTO.name
        views.text = "Viewers: \(detailDTO.views)"
        channels.text = "Channels: \(detailDTO.channels)"
        poster.image = viewModel.getImage()
    }
    
    func fill(with dto: GameDetailDTO) {
        detailDTO = dto
    }
    
    // MARK: - DetailGameLoadContent
    func didLoadImage() {
        poster.image = viewModel.imageFromCache()
    }
}
