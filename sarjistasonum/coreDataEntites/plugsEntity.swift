//
//  plugsEntity.swift
//  sarjistasonum
//
//  Created by Yusiff on 1.12.2024.
//

import Foundation
import CoreData

@objc(PlugsEntity)
public class PlugsEntity: NSManagedObject {
   

    @NSManaged public var type: String
    @NSManaged public var power: Double
    @NSManaged public var price: Double

    @NSManaged public var chargingStation: ChargingStationsEntity?
}

extension PlugsEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlugsEntity> {
        return NSFetchRequest<PlugsEntity>(entityName: "PlugsEntity")
    }
}

