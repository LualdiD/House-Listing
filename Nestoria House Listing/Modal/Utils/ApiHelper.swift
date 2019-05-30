//
//  Constants.swift
//  Nestoria House Listing
//
//  Created by Dylan Lualdi on 29/05/2019.
//  Copyright © 2019 Dylan Lualdi. All rights reserved.
//

import Foundation

struct ApiHelper {
    
    // get api url
    static func api(priceMin: String = Constant.min_value, priceMax: String = Constant.max_value, bedroomsMin: String = Constant.min_value, bedroomsMax: String = Constant.max_value, city: String = Constant.default_city) -> String {
        
        let priceMax = priceMax == "0" ? Constant.max_value : priceMax
        let bedroomsMax = bedroomsMax == "0" ? Constant.max_value : bedroomsMax
        let url = "https://api.nestoria.co.uk/api?encoding=json&action=search_listings&place_name=\(city)&price_min=\(priceMin)&price_max=\(priceMax)&bedroom_min=\(bedroomsMin)&bedroom_max=\(bedroomsMax)&number_of_results=50"
        
        print("check url \(url)")
        
        return url
    }
}
