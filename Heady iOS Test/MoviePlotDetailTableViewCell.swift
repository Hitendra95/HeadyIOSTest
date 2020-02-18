//
//  MoviePlotDetailTableViewCell.swift
//  Heady iOS Test
//
//  Created by Hitendra Dubey on 17/02/20.
//  Copyright © 2020 Hitendra Dubey. All rights reserved.
//

import UIKit

class MoviePlotDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var moviePlotTitle: UILabel!
    @IBOutlet weak var moviePlotDetails: UILabel!
    class var reuseIdentifier: String{return String(describing: self)}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
