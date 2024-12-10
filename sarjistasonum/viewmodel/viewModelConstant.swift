//
//  viewModelConstant.swift
//  sarjistasonum
//
//  Created by Yusiff on 25.11.2024.
//

import Foundation

protocol outPut : AnyObject{
    func outPut(_ endpoint: endPointOutPut)
}

enum endPointOutPut{
    case nearest ([ChargingStation])
}
