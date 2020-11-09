//
//  AppCoordinator.swift
//  gaSPopularity
//
//  Created by Oleksandr Hozhulovskyi on 25.10.2020.
//

import UIKit

class AppCoordinator {
    let window: UIWindow
    var navigationController: UINavigationController
    let store: GasStationsStore
    lazy var gasStationsViewModel = GasStationsViewModel(store: store)


    init(window: UIWindow, store: GasStationsStore = GasStationsStore()) {
        self.window = window
        self.navigationController = window.rootViewController as! UINavigationController
        self.store = store
    }

    func start() {
        let gasStationsViewController = navigationController.topViewController as! GasStationsViewController

        gasStationsViewModel.showEditGasStation = showEditGasStation

        gasStationsViewController.viewModel = gasStationsViewModel
    }

    func showEditGasStation(mode: EditGasStationMode, record: GasRecord) {
        let storyboard = navigationController.storyboard
        let editGasStationViewController = storyboard?.instantiateViewController(identifier: "EditGasStationViewController") as! EditGasStationViewController

        let viewModel = EditGasStationViewModel(mode: mode,
                                                record: record,
                                                store: store)
        viewModel.recordSaved = {
            self.navigationController.popToRootViewController(animated: true)
            self.gasStationsViewModel.stationsUpdated?()
        }
        editGasStationViewController.viewModel = viewModel

        navigationController.pushViewController(editGasStationViewController, animated: true)
    }
}
