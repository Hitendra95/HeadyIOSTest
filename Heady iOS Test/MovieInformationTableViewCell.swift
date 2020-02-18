//
//  MovieInformationTableViewCell.swift
//  Heady iOS Test
//
//  Created by Hitendra Dubey on 17/02/20.
//  Copyright © 2020 Hitendra Dubey. All rights reserved.
//

import UIKit

class MovieInformationTableViewCell: UITableViewCell {
class var reuseIdentifier: String{return String(describing: self)}
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet var movieNumberOfStars: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for image in movieNumberOfStars
        {
            image.image = UIImage(named: "icons8-star-24")
            image.tintColor = .gray
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
