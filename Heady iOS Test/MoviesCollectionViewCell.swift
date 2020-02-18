//
//  MoviesCollectionViewCell.swift
//  Heady iOS Test
//
//  Created by Hitendra Dubey on 17/02/20.
//  Copyright © 2020 Hitendra Dubey. All rights reserved.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {

    class var reuseIdentifier: String{return String(describing: self)}
    
    @IBOutlet weak var movieImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
