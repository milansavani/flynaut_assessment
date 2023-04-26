//
//  UIViewController+Extension.swift
//  FlynautAssessment
//
//  Created by iMac on 25/04/23.
//

import Foundation
import UIKit

extension UIViewController {

    // It shows activity indicator for loading at the center of the view of the ViewController
    func showLoader() {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.tintColor = UIColor.green
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }

    // It removes the activity indicator from view of ViewController
    func hideLoader() {
        view.subviews.filter({ $0 is UIActivityIndicatorView}).forEach { loader in
            (loader as? UIActivityIndicatorView)?.stopAnimating()
            (loader as? UIActivityIndicatorView)?.removeFromSuperview()
        }
    }

}
