//
//  AddressService.swift
//  gaSPopularity
//
//  Created by Oleksandr Hozhulovskyi on 08.11.2020.
//

import Foundation
import CoreLocation

class AddressService {
    let geocoder: CLGeocoder

    init(geocoder: CLGeocoder = CLGeocoder()) {
        self.geocoder = geocoder
    }
    func getAddress(from location: CLLocation, completion: @escaping (Result<String, Error>) -> Void) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            let placemark = placemarks?.first
            var address = ""

            if let town = placemark?.subAdministrativeArea {
                address += town
            }
            if let street = placemark?.thoroughfare {
                address += ", " + street
            }
            if let buildingNumber = placemark?.subThoroughfare {
                address += ", " + buildingNumber
            }

            completion(.success(address))
        }
    }

}
