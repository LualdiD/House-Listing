//
//  HouseTableViewCell.swift
//  Nestoria House Listing
//
//  Created by Dylan Lualdi on 30/05/2019.
//  Copyright © 2019 Dylan Lualdi. All rights reserved.
//

import UIKit
import Kingfisher

class HouseTableViewCell: UITableViewCell {
    
    @IBOutlet var houseNameLabel: UILabel!
    @IBOutlet var houseDescriptionLabel: UILabel!
    @IBOutlet var housePriceLabel: UILabel!
    @IBOutlet var houseImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(name: String, description: String, price: String, imgUrl: String) {
        houseNameLabel.text = name
        houseDescriptionLabel.text = description
        housePriceLabel.text = price
        setImageFromURL(url: imgUrl, to: houseImageView)
    }
    
    func setImageFromURL(url: String,to imageView: UIImageView) {
        let url = URL(string: url)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, options: [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
            ])
    }
}
