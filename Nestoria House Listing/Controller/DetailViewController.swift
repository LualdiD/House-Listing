//
//  DetailViewController.swift
//  Nestoria House Listing
//
//  Created by Dylan Lualdi on 30/05/2019.
//  Copyright © 2019 Dylan Lualdi. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var houseImageView: UIImageView!
    @IBOutlet var priceButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var advertiserTextView: UITextView!
    
    var house: House?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImageFromURL(url:house?.imgURL ?? "", to: houseImageView)
        priceButton.setTitle(house?.priceFormatted, for: .normal)
        nameLabel.text = self.house?.title
        summaryLabel.text = self.house?.summary
        if let lister = self.house?.listerName {
            advertiserTextView.text = "Advertised by: \(lister)"
        } else {
            advertiserTextView.isHidden = true
        }
        
        if let lat = house?.latitude, let long = house?.longitude {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            mapView.addAnnotation(annotation)
            mapView.fitAllMarkers(shouldIncludeCurrentLocation: false)
        }
        
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
