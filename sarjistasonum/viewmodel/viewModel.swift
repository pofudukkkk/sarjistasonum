//
//  viewModel.swift
//  sarjistasonum
//
//  Created by Yusiff on 25.11.2024.
//

import Foundation

final class viewModel{
    var services:services?
    weak var delegate: outPut?
    
    init(services: services? = nil) {
        self.services = services
    }
    
    
    func fetchData(){
        services?.getData(.nearest, completion: { (result: Result<chargeModel,chargeError>) in
            switch result{
            case .success(let charger):
                self.delegate?.outPut(.nearest(charger.chargingStations))
            case .failure(let error):
                switch error{
                case .parseError:
                    print("PARSE ERROR")
                case .serverError:
                    print("SERVER ERROR")
                }
            }
        })
    }

}
