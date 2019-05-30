//
//  House.swift
//  Nestoria House Listing
//
//  Created by Dylan Lualdi on 30/05/2019.
//  Copyright © 2019 Dylan Lualdi. All rights reserved.
//

import Foundation

struct House {
    let imgURL: String?
    let latitude: Double?
    let longitude: Double?
    let listerURL: String?
    let price: Int?
    let priceFormatted: String?
    let summary: String?
    let title: String?
    let listerName: String?
    init(_ dictionary: [String: Any]) {
        self.imgURL = dictionary["img_url"] as? String
        self.latitude = dictionary["latitude"] as? Double
        self.longitude = dictionary["longitude"] as? Double
        self.listerURL = dictionary["lister_url"] as? String
        self.price = dictionary["price"] as? Int
        self.priceFormatted = dictionary["price_formatted"] as? String
        self.summary = dictionary["summary"] as? String
        self.title = dictionary["title"] as? String
        self.listerName = dictionary["lister_name"] as? String
    }
}
