//
//  networkCaller.swift
//  sarjistasonum
//
//  Created by Yusiff on 25.11.2024.
//

import Foundation

enum chargeError:Error{
    case serverError
    case parseError
}

protocol networkServicesProtocol{
    func getData<T:Codable>(_ endPoint:endPoint, completion:@escaping(Result<T,chargeError>)->Void)
}

final class services:networkServicesProtocol{
    func getData<T:Codable>(_ endPoint:endPoint, completion:@escaping(Result<T,chargeError>)->Void){
        URLSession.shared.dataTask(with: endPoint.request()) { data, response, error in
            if error != nil{
                completion(.failure(chargeError.serverError))
                    print("serverError")
                }
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200, response.statusCode <= 299 else{
                fatalError("NOT RESPONSE")
            }
            
            guard let data = data else{
                fatalError("Not Data")
            }
            
            let jsonResponse = try? JSONDecoder().decode(T.self, from: data)
            if let jsonResponse = jsonResponse{
                completion(.success(jsonResponse))
            }
            
            
                
        } .resume()
        }
    }

