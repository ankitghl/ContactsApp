//
//  UIViewController+Helpers.swift
//  Contacts
//
//  Created by Ankit.Gohel on 08/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

extension UIViewController {
   
    func showAlert(title: String? , message: String? , style: UIAlertController.Style, actions: [UIAlertAction]) {
        let alertViewController = UIAlertController(title: title, message: message , preferredStyle: style)
        let oK = UIAlertAction(title: "OK", style: .default) { (alert) in
        }
        alertViewController.addAction(oK)
        DispatchQueue.main.async {
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func showActivityIndicator() {
        if let activityView = view.viewWithTag(1000) as? UIActivityIndicatorView { activityView.startAnimating(); return }
        let activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.tag = 1000
        activityView.center = self.view.center
        activityView.hidesWhenStopped = true
        activityView.color = UIColor(red: 79/255, green: 227/255, blue: 194/255, alpha: 1)
        activityView.startAnimating()
        view.addSubview(activityView)
        activityView.bringSubviewToFront(activityView)
    }
    
    func hideActivityIndicator() {
        if let activityView = view.viewWithTag(1000) as? UIActivityIndicatorView {
            activityView.stopAnimating()
        }
    }
}

extension UIView {
   
    func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor(red: 79/255, green: 227/255, blue: 194/255, alpha: 1).cgColor]
        gradientLayer.locations = [0.0, 2.5]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
