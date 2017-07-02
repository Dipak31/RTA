//
//  FancyButton.swift
//  Casting Finder
//
//  Created by Dipak on 13/12/16.
//  Copyright © 2016 Dipak. All rights reserved.
//

import UIKit

@IBDesignable public class FancyButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = UIColor(hex:Colors.blue) {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 4.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
    }
}
