//
//  GasStationsStore.swift
//  gaSPopularity
//
//  Created by Oleksandr Hozhulovskyi on 25.10.2020.
//

import Foundation

class GasStationsStore {
    let firebaseService: FirebaseService
    
    private(set) var records = [GasRecord]() {
        didSet {
            stationsStatictic.removeAll()
            records.forEach {
                stationsStatictic[$0.stationName, default: 0] += 1
            }
        }
    }
    private(set) var stationsStatictic = [String: Int]()

    init(firebaseService: FirebaseService = FirebaseService()) {
        self.firebaseService = firebaseService
    }

    func save(_ record: GasRecord, isNew: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        firebaseService.addStationToFirebase(record) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                if isNew {
                    self?.records.insert(record, at: 0)
                }
                completion(.success(()))
            }
        }
    }

    func delete(at index: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let record = records[index]

        firebaseService.deleteGasStation(record) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case.success(()):
                self?.records.remove(at: index)
                completion(.success(()))
            }
        }
    }

    func updateAll(completion: @escaping (Result<Void, Error>) -> Void) {
        firebaseService.getGasStations { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let records):
                self?.records = records
                completion(.success(()))
            }
        }
    }
}
