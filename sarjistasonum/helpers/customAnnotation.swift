//
//  customAnnotation.swift
//  sarjistasonum
//
//  Created by Yusiff on 30.11.2024.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

    var locationData: ChargingStation
    var title: String?

    
    init(location: ChargingStation) {
        self.coordinate = CLLocationCoordinate2D(latitude:location.geoLocation.lat , longitude: location.geoLocation.lon)
        self.title = location.title
        self.locationData = location
    }
}
