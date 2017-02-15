//
//  LoadingButton.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 5/17/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    
    var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
    
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", forState: UIControlState.Normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideLoading() {
        self.setTitle(originalButtonText, forState: UIControlState.Normal)
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.lightGrayColor()
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: activityIndicator, attribute: .CenterX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: activityIndicator, attribute: .CenterY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
}

