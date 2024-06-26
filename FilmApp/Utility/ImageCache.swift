//
//  ImageCache.swift
//  FilmApp
//
//  Created by Taha Chaouch on 26/6/2024.
//

import Foundation
import UIKit


// Image caching utility
class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
