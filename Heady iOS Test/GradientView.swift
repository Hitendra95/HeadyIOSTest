//
//  GradientView.swift
//  Heady iOS Test
//
//  Created by Hitendra Dubey on 17/02/20.
//  Copyright © 2020 Hitendra Dubey. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }


}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    func loadImageUsingCacheWithUrl(urlString: String) {
        self.image = nil

        /// check for cache
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }

        /// download image from url
        if urlString == ""
        {
            return
        }
        let url = URL(string: urlString)
        if url != nil
        {
        //print("url abc  : \(url)")
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in

            guard error == nil
                else { return }
            guard let downloadedImage = UIImage(data: data!)
                else {return }

            performUIUpdatesOnMain {
                imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                self.image = downloadedImage
            }


        }).resume()
        }
    }
}

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
DispatchQueue.main.async {
    updates()
    }
}
