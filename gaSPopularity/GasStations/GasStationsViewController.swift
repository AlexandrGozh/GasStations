//
//  GasStationsViewController.swift
//  gaSPopularity
//
//  Created by Oleksandr Hozhulovskyi on 25.10.2020.
//

import UIKit

class GasStationsViewController: UIViewController, ErrorShowable {
    @IBOutlet weak var gasStationsTableView: UITableView!

    var viewModel: GasStationsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.viewViewAppear()
    }

    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.editGasStation()
    }

    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        viewModel.segmentIndexChanged(sender.selectedSegmentIndex)
    }

    private func bindViewModel() {
        viewModel.stationsUpdated = { [weak self] in
            self?.gasStationsTableView.reloadData()
        }

        viewModel.showError = { [weak self] in
            self?.showError($0)
        }
    }
}

extension GasStationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GasStationReusableCell") else {
            fatalError("Can't find cell with identifier \"GasStationReusableCell\"")
        }

        cell.isUserInteractionEnabled = viewModel.canEdit
        cell.accessoryType = viewModel.canEdit ? .disclosureIndicator : .none

        let data = viewModel.stationData(at: indexPath)

        cell.textLabel?.text = data.name
        cell.detailTextLabel?.text = data.detail

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        viewModel.editGasStation(at: indexPath)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.canEdit
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            viewModel.deleteGasStation(at: indexPath)
        }
    }
}
