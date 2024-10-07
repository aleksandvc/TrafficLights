//
//  UIView+Extensions.swift
//  TrafficLights
//
//  Created by Sasha Belov on 7.10.24.
//

import UIKit

extension UIView {
    
    func createCircleView(size: CGFloat) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: size),
            self.widthAnchor.constraint(equalToConstant: size)
        ])
        
        self.layer.cornerRadius = size/2
        self.clipsToBounds = true
        
        return self
    }
}
