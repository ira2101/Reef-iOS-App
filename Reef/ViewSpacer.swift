//
//  ViewSpacer.swift
//  Reef
//
//  Created by Ira Einbinder on 2/13/22.
//

import UIKit

class ViewSpacer: UIView {
    convenience init(width: CGFloat, height: CGFloat) {
        self.init()
        
        self.backgroundColor = .clear
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    convenience init(width: CGFloat) {
        self.init()
        
        self.backgroundColor = .clear
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    convenience init(height: CGFloat) {
        self.init()
        
        self.backgroundColor = .clear
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
