//
//  GasStationsViewController.swift
//  gaSPopularity
//
//  Created by Oleksandr Hozhulovskyi on 07.11.2020.
//

import UIKit

protocol ErrorShowable {
    func showError(_ errorString: String)
}

extension ErrorShowable where Self: UIViewController {
    func showError(_ errorString: String) {
        let alert = UIAlertController(title: "Error",
                                      message: errorString,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alert, animated: true)
    }
}
