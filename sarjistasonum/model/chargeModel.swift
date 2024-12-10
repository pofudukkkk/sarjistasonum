//
//  chargeModel.swift
//  sarjistasonum
//
//  Created by Yusiff on 25.11.2024.
//

import Foundation

// MARK: - Welcome
struct chargeModel: Codable {
    let total, distance: Int
    let distanceUnit: String
    let chargingStations: [ChargingStation]
}

// MARK: - ChargingStation
 struct ChargingStation: Codable {
    let id: Int
    let title: String
    let location: Location
    let geoLocation: GeoLocation
    let chargingStationOperator: Operator
    let reservationURL: String?
    let phone: String
    let stationActive: Bool
    let plugs: [Plug]
    let plugsTotal: Int
    let provider: Provider
    let paymentTypes: [PaymentType]
    let provideLiveStats: Bool
    let distance: Double

    enum CodingKeys: String, CodingKey {
        case id, title, location, geoLocation
        case chargingStationOperator = "operator"
        case reservationURL = "reservationUrl"
        case phone, stationActive, plugs, plugsTotal, provider, paymentTypes, provideLiveStats, distance
    }
}

// MARK: - Operator
struct Operator: Codable {
    let id: Int
    let title, brand: String
}

// MARK: - GeoLocation
struct GeoLocation: Codable {
    let lat, lon: Double
}

// MARK: - Location
struct Location: Codable {
    let cityID: Int
    let cityName: JSONNull?
    let districtID: Int
    let districtName: JSONNull?
    let address: String
    let lat, lon: Double

    enum CodingKeys: String, CodingKey {
        case cityID = "cityId"
        case cityName
        case districtID = "districtId"
        case districtName, address, lat, lon
    }
}

// MARK: - PaymentType
struct PaymentType: Codable {
    let name: Name
}

enum Name: String, Codable {
    case mobilodeme = "MOBILODEME"
}

// MARK: - Plug
struct Plug: Codable {
    let id: Int
    let type: TypeEnum
    let subType: SubType
    let socketNumber: String
    let power, price: Double
    let count: Int
}

enum SubType: String, Codable {
    case acType2 = "AC_TYPE2"
    case dcCcs = "DC_CCS"
    case dcChademo = "DC_CHADEMO"
}

enum TypeEnum: String, Codable {
    case ac = "AC"
    case dc = "DC"
}

enum Provider: String, Codable {
    case epdk = "EPDK"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public func hash(into hasher: inout Hasher) {
          hasher.combine(0)
      }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
