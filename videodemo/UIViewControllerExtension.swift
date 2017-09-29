//
//  UIViewControllerExtension.swift
//  videodemo
//
//  Created by Mallabelly, Manikanta on 9/28/17.
//  Copyright © 2017 Mallabelly, Manikanta. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: Constants.alertButtonTitle,
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
