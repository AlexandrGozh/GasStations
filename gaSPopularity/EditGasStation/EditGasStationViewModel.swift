//
//  EditGasStationViewModel.swift
//  gaSPopularity
//
//  Created by Oleksandr Hozhulovskyi on 25.10.2020.
//

import Foundation
import MapKit
import CoreLocation

enum EditGasStationMode {
    case create
    case edit

    var buttonName: String {
        switch self {
        case .create:
            return "Create"
        case .edit:
            return "Save"
        }
    }

    var viewTitle: String {
        switch self {
        case .create:
            return "Create station"
        case .edit:
            return "Edit station"
        }
    }
}

class EditGasStationViewModel {
    let mode: EditGasStationMode
    let store: GasStationsStore
    let addressService: AddressService
    private(set) var record: GasRecord

    var recordSaved: (() -> Void)?
    var addressUpdated: ((String) -> Void)?
    var showError: ((String) -> Void)?

    var segmentIndex: Int {
        return record.fuelType.rawValue
    }
    var center: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: record.latitude,
                               longitude: record.longitude)
    }

    private var timer = Timer()

    init(mode: EditGasStationMode,
         record: GasRecord,
         store: GasStationsStore,
         addressService: AddressService = AddressService()) {
        self.mode = mode
        self.record = record
        self.store = store
        self.addressService = addressService
    }

    func save(name: String?,
              address: String?,
              quantity: String?,
              price: String?,
              fuelType: Int) {
        guard let name = name, !name.isEmpty,
              let address = address,
              let quantity = quantity, let doubleQuantity = Double(quantity),
              let price = price, let doublePrice = Double(price),
              let fuelType = GasRecord.FuelType(rawValue: fuelType)
        else {
            showError?("Fill in all text fields")
            return
        }

        record.stationName = name
        record.address = address
        record.quantity = doubleQuantity
        record.price = doublePrice
        record.fuelType = fuelType

        saveGasStation()
    }

    private func saveGasStation() {
        store.save(record, isNew: mode == .create) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showError?(error.localizedDescription)
            case .success():
                self?.recordSaved?()
            }
        }
    }

    func coordinateUpdated(_ coordinate: CLLocationCoordinate2D) {
        record.latitude = coordinate.latitude
        record.longitude = coordinate.longitude

        // Debounce address query
        timer.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

            self.getAddress(from: location)
        }
    }

    private func getAddress(from location: CLLocation) {
        addressService.getAddress(from: location) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showError?(error.localizedDescription)
            case .success(let address):
                self?.record.address = address
                self?.addressUpdated?(address)
            }
        }
    }
}
