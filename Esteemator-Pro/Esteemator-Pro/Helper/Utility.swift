//
//  Utility.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 10/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import Foundation
import UIKit

class FormulasUtility {
    
    func numberFormat(baseNumber: Double) -> String {
        let number = baseNumber as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        let converted = numberFormatter.string(from: number)
        
        return converted!
    }
}


extension UIView {
    
    func jitter() {
        let animations = CABasicAnimation(keyPath: "position")
        animations.duration = 0.05
        animations.repeatCount = 3
        animations.autoreverses = true
        animations.fromValue = NSValue(cgPoint: CGPoint.init(x: self.center.x - 5.0, y: self.center.y ))
        animations.toValue = NSValue(cgPoint: CGPoint.init(x: self.center.x + 5.0, y: self.center.y))
        layer.add(animations, forKey: "position")
    }
    
}

//
@IBDesignable
class UIButtonR: UIButton  {
    
    @IBInspectable var cornerRadius: CGFloat = 3 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
