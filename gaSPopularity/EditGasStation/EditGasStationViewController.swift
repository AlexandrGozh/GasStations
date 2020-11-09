//
//  EditGasStationViewController.swift
//  gaSPopularity
//
//  Created by Oleksandr Hozhulovskyi on 25.10.2020.
//

import UIKit
import MapKit
import CoreLocation

class EditGasStationViewController: UIViewController, ErrorShowable {

    @IBOutlet weak var gasStationNameTextField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var fuelTypeControl: UISegmentedControl!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userLocationButton: UIButton!
    
    var viewModel: EditGasStationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self

        editBarButton.title = viewModel.mode.buttonName
        navigationItem.title = viewModel.mode.viewTitle

        configureUserLocationButton()
        setTextFieldsIfNeeded()
        centerMapToAddress()
        fuelTypeControl.selectedSegmentIndex = viewModel.segmentIndex
        bindViewModel()
    }
    
    @IBAction func editBarButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.save(name: gasStationNameTextField.text,
                       address: addressLabel.text,
                       quantity: quantityTextField.text,
                       price: priceTextField.text,
                       fuelType: fuelTypeControl.selectedSegmentIndex)
    }

    @IBAction func userLocationButtonTapped(_ sender: Any) {
        userLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        mapView.userTrackingMode = .follow

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.userLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
        }
    }

    private func bindViewModel() {
        viewModel.showError = { [weak self] in
            self?.showError($0)
        }

        viewModel.addressUpdated = { [weak self] in
            self?.addressLabel.text = $0
        }
    }

    private func configureUserLocationButton() {
        userLocationButton.layer.cornerRadius = 5
        userLocationButton.layer.borderWidth = 0.5
        userLocationButton.layer.borderColor = UIColor.systemBlue.cgColor
    }

    private func setTextFieldsIfNeeded() {
        guard viewModel.mode == .edit else { return }

        gasStationNameTextField.text = viewModel.record.stationName
        addressLabel.text = viewModel.record.address
        quantityTextField.text = String(viewModel.record.quantity)
        priceTextField.text = String(viewModel.record.price)
    }

    private func centerMapToAddress() {
        switch viewModel.mode {
        case .create:
            mapView.userTrackingMode = .follow
        case .edit:
            mapView.setRegion(MKCoordinateRegion(center: viewModel.center,
                                                 latitudinalMeters: 300,
                                                 longitudinalMeters: 300),
                              animated: true)
        }
    }
}

extension EditGasStationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.viewModel.coordinateUpdated(mapView.centerCoordinate)
    }
}
