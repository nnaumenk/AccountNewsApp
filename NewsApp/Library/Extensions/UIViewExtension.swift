//
//  UIViewExtension.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2020 Nazar NAUMENKO. All rights reserved.
//

import Foundation

import Foundation
import UIKit

extension UIView {
    
    var numberOfCurrentQueries: Int {
        return activityIndicatorData.numberOfCurrentQueries
    }
    
    struct activityIndicatorData {
        static var numberOfCurrentQueries = 0
    }
    
    func startActivityIndicator() {
        activityIndicatorData.numberOfCurrentQueries += 1
        if activityIndicatorData.numberOfCurrentQueries != 1 { return }
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.accessibilityIdentifier = "activityIndicator"
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        activityIndicator.startAnimating()
    }
    
    
    func stopActivityIndicator() {
        
        if activityIndicatorData.numberOfCurrentQueries == 0 { return }
        activityIndicatorData.numberOfCurrentQueries -= 1
        if activityIndicatorData.numberOfCurrentQueries > 0 { return }
        
        guard let activityIndicator = self.subviews.first(where: { $0.accessibilityIdentifier == "activityIndicator" }) as? UIActivityIndicatorView else { return }
        
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    
}
