//
//  FirebaseService.swift
//  gaSPopularity
//
//  Created by Oleksandr Hozhulovskyi on 25.10.2020.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class FirebaseService {
    let dataBase = Firestore.firestore()
    private let collection = "GasStations"

    func addStationToFirebase(_ gasStation: GasRecord, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try dataBase
                .collection(collection)
                .document(gasStation.id)
                .setData(from: gasStation)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    func getGasStations(completion: @escaping (Result<[GasRecord], Error>) -> Void) {
        dataBase.collection(collection).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let snapshot = snapshot {
                let stations = snapshot.documents.compactMap{ record -> GasRecord? in
                    try? record.data(as: GasRecord.self)
                }

                completion(.success(stations))
            }
        }
    }

    func deleteGasStation(_ gasStation: GasRecord, completion: @escaping (Result<Void, Error>) -> Void) {
        dataBase
            .collection(collection)
            .document(gasStation.id)
            .delete() { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                completion(.success(()))
        }
    }
}
