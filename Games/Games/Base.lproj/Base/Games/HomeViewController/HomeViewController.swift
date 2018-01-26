//
//  HomeViewController.swift
//  Games
//
//  Created by Vinicius on 23/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, LoadContent, GameCellDelegate {

    // MARK: - Attributes
    lazy var viewModel: HomeViewModelDelegate = HomeViewModel(delegate: self)
    let refresher = UIRefreshControl()
    
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
        addRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.isUserInteractionEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailViewcontroller = segue.destination as? DetailViewController, let dto = sender as? GameDetailDTO {
                detailViewcontroller.fill(with: dto)
            }
        }
    }
    
    
    // MARK: - Private methods
    private func addRefresh() {
        self.collectionView?.alwaysBounceVertical = true
        self.refresher.tintColor = .white
        self.refresher.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.collectionView?.addSubview(refresher)
    }
    
    @objc func refresh() {
        viewModel.refresh()
    }
    
    
    // MARK: - LoadContent
    func feedback(error: String?) {
        if let errorMessage = error {
            showDefaultAlert(message: errorMessage, completeBlock: nil)
        }
        
        DispatchQueue.main.async {
            self.dismissLoader()
            self.refresher.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    
    func didLoadImage(identifier: String) {
        DispatchQueue.main.async {
            guard let collection = self.collectionView else {
                return
            }
            for cell in collection.visibleCells {
                if let gameCell = cell as? GameCell, gameCell.identifier == identifier {
                    gameCell.setImage(with: self.viewModel.imageFromCache(identifier: identifier))
                }
            }
        }
    }
    
    //MARK: - UICollectionViewDataSource/Delegate
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = GameCell.createCell(collectionView: collectionView, indexPath: indexPath) as GameCell
        cell.delegate = self
        cell.fill(with: viewModel.getGameDTO(at: indexPath.row))
        if indexPath.row == viewModel.numberOfItems() - 1 && viewModel.canLoad {
            showLoader()
            viewModel.getGames()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let gameCell = cell as? GameCell {
            gameCell.fill(with: viewModel.getGameDTO(at: indexPath.row))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        performSegue(withIdentifier: "showDetail", sender: viewModel.getGameDetailDTO(at: indexPath.row))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItems(with: view.frame.size.width, height: view.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    
    // MARK: - GameCellDelegate
    func didFavorite(with id: Int, shouldFavorite: Bool, imageData: Data?) {
        viewModel.didFavorite(with: id, shouldFavorite: shouldFavorite, imageData: imageData)
    }
}
