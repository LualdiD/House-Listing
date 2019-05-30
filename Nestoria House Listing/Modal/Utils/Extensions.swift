//
//  Extensions.swift
//  Nestoria House Listing
//
//  Created by Dylan Lualdi on 30/05/2019.
//  Copyright © 2019 Dylan Lualdi. All rights reserved.
//

import Foundation
import MapKit

// MARK: - STRING Extensions
extension String {
    var convertToPrice: String? {
        guard let value = Double(self) else { return self }
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        if let priceString = currencyFormatter.string(for: value) {
            return priceString
        }
        return self
    }
}

// MARK: - MapView Extensions
extension MKMapView {
    func fitAllMarkers(shouldIncludeCurrentLocation: Bool) {
        
        if !shouldIncludeCurrentLocation
        {
            showAnnotations(annotations, animated: true)
        }
        else
        {
            var zoomRect = MKMapRect.null
            
            let point = MKMapPoint(userLocation.coordinate)
            let pointRect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
            zoomRect = zoomRect.union(pointRect)
            
            for annotation in annotations {
                
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
                
                zoomRect = zoomRect.union(pointRect)
            }
            
            setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), animated: true)
        }
    }
}
