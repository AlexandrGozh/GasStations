//
//  GasStationsViewModel.swift
//  gaSPopularity
//
//  Created by Oleksandr Hozhulovskyi on 25.10.2020.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class GasStationsViewModel {
    let store: GasStationsStore

    var showEditGasStation: ((EditGasStationMode, GasRecord) -> Void)?
    var stationsUpdated: (() -> Void)?
    var showError: ((String) -> Void)?

    private var mode: ViewMode = .history
    private var allStations = [GasRecord]()

    private lazy var stationsStatictic: [String: Int] = [:]

    var numberOfRows: Int {
        switch mode {
        case .history:
            return store.records.count
        case .statistics:
            return store.stationsStatictic.count
        }
    }

    var canEdit: Bool { mode == .history }

    init(store: GasStationsStore) {
        self.store = store
    }

    func viewViewAppear() {
        updateData()
    }
    
    func segmentIndexChanged(_ index: Int) {
        mode = ViewMode(rawValue: index) ?? .history

        updateData()
    }

    private func updateData() {
        store.updateAll { result in
            switch result {
            case .failure(let error):
                self.showError?(error.localizedDescription)
            case .success():
                self.stationsUpdated?()
            }
        }
    }

    func stationData(at indexPath: IndexPath) -> StationData {
        let name: String
        let detail: String

        switch mode {
        case .history:
            let record = store.records[indexPath.row]
            name = record.stationName
            detail = record.address
        case .statistics:
            name = store.stationsStatictic.keys.sorted()[indexPath.row]
            detail = "Visits: \(store.stationsStatictic[name, default: 0])"
        }

        return StationData(name: name, detail: detail)
    }

    func deleteGasStation(at indexPath: IndexPath) {
        store.delete(at: indexPath.row) { result in
            switch result {
            case .failure(let error):
                self.showError?(error.localizedDescription)
            case.success(()):
                self.stationsUpdated?()
            }
        }
    }

    func editGasStation(at indexPath: IndexPath? = nil) {
        if let index = indexPath?.row {
            showEditGasStation?(.edit, store.records[index])
        } else {
            showEditGasStation?(.create, GasRecord())
        }
    }
}

extension GasStationsViewModel {
    enum ViewMode: Int {
        case history = 0
        case statistics
    }

    struct StationData {
        let name: String
        let detail: String
    }
}
