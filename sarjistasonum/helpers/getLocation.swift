//
//  getLocation.swift
//  sarjistasonum
//
//  Created by Yusiff on 25.11.2024.
//

import Foundation
import CoreLocation

final class getLocation:NSObject, CLLocationManagerDelegate{
    static let shared = getLocation()
    
    private override init() {}
    
    var locationManager = CLLocationManager()
    var latitude:Double?
    var longitude:Double?
    
    func takeLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        latitude = locationManager.location?.coordinate.latitude ?? 1.2
        longitude = locationManager.location?.coordinate.longitude ?? 0.90
        print(latitude!)
        print(longitude!)
    }
}
