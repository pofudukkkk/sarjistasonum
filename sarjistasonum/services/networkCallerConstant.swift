//
//  networkCallerConstant.swift
//  sarjistasonum
//
//  Created by Yusiff on 25.11.2024.
//

import Foundation

protocol networkCallerProtocol{
    var baseUrl:String{get}
    var latitude:String{get}
    var longitude:String{get}
    var genreUrl:String{get}
    var lastUrl:String{get}
    
    var httpMethod:httpMethod {get}
    
    func apiUrl()->String
    func request()->URLRequest
}

enum endPoint{
    case nearest
}

enum httpMethod:String{
    case get = "GET"
}


extension endPoint:networkCallerProtocol{
    var baseUrl: String {
        return "...."
    }
    
    var genreUrl: String {
        switch self {
        case .nearest:
            return "...."
        }
    }
    
    
    var latitude: String {
        getLocation.shared.takeLocation()
        let x = getLocation.shared.locationManager.location?.coordinate.latitude ?? 11.22
        return "latitude=\(x)"
    }
    
    var longitude: String {
        getLocation.shared.takeLocation()
        let y = getLocation.shared.locationManager.location?.coordinate.longitude ?? 33.44
        return "&longitude=\(y)"
    }
    
    var lastUrl: String{
        return "...."
    }
    
    func apiUrl() -> String {
        let url = baseUrl+genreUrl+latitude+longitude+lastUrl
        print(url)
        return url
    }
    
    var httpMethod: httpMethod{
        switch self{
        case .nearest:
            return .get
        }
    }
    
    func request() -> URLRequest {
        guard let aUrl = URLComponents(string: apiUrl()) else {
            fatalError("HATA")
        }
        
        guard let url = aUrl.url else {
            fatalError("NOT URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }
    
    
}


