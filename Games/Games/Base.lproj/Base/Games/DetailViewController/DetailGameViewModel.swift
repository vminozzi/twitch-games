//
//  DetailGameViewModel.swift
//  Games
//
//  Created by Vinicius on 24/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation
import UIKit

protocol DetailGameLoadContent: class {
    func didLoadImage()
}

protocol DetailGameViewModelDelegate: class {
    func getImage() -> UIImage?
    func imageFromCache() -> UIImage?
}

class DetailGameViewModel: DetailGameViewModelDelegate {
    
    private var imageId = ""
    weak var loadContentDelegate: DetailGameLoadContent?
    private var cache = NSCache<NSString, UIImage>()
    
    init(delegate: DetailGameLoadContent, imageId: String, width: CGFloat) {
        loadContentDelegate = delegate
        var imageString = imageId.replacingOccurrences(of: "{height}", with: "250")
        imageString = imageString.replacingOccurrences(of: "{width}", with: "\(width)")
        imageString = imageString.replacingOccurrences(of: ".0", with: "")
        self.imageId = imageString
    }
    
    // MARK: - CachedImageLoadContent
    func didLoadImage(identifier: String) {
        loadContentDelegate?.didLoadImage()
    }
    
    func getImage() -> UIImage? {
        if let imageCached = cache.object(forKey: NSString(string: imageId)) {
            return imageCached
        }
        
        let placeholder = UIImage(named: "placeholder-icon")
        placeholder?.accessibilityIdentifier = "placeholder"
        cache.setObject(placeholder ?? UIImage(), forKey: NSString(string: imageId))
        
        if let url = URL(string: imageId) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: NSString(string: self.imageId))
                        self.loadContentDelegate?.didLoadImage()
                    }
                }
            }).resume()
        }
        return nil
    }
    
    func imageFromCache() -> UIImage? {
        return cache.object(forKey: NSString(string: imageId))
    }
}
