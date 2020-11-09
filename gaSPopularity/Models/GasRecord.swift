//
//  GasRecord.swift
//  gaSPopularity
//
//  Created by Oleksandr Hozhulovskyi on 25.10.2020.
//

import UIKit

struct GasRecord: Codable {
    var id = UUID().uuidString
    var stationName = ""
    var address = ""
    var fuelType = FuelType.diesel
    var quantity = 0.0
    var price = 0.0
    var latitude = 0.0
    var longitude = 0.0
}

extension GasRecord {
    enum FuelType: Int, Codable {
        case diesel = 0
        case regular
        case plus
        case premium
    }
}
