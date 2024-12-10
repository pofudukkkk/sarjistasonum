//
//  chargingStationEntity.swift
//  sarjistasonum
//
//  Created by Yusiff on 1.12.2024.
//

import Foundation
import CoreData

@objc(ChargingStationsEntity)
public class ChargingStationsEntity: NSManagedObject {
    @NSManaged public var title: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var company: String
    @NSManaged public var plugsTotal :Int32
    @NSManaged public var distance:Double
    @NSManaged public var plugs: NSSet?
}

extension ChargingStationsEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChargingStationsEntity> {
        return NSFetchRequest<ChargingStationsEntity>(entityName: "ChargingStationsEntity")
    }
}
