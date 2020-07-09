//
//  AYGradientView.swift
//  iWallet
//
//  Created by YUXI on 2019/4/29.
//  Copyright © 2019 YUXI. All rights reserved.
//

import Foundation
import UIKit


//@IBDesignable
class AYGradientView: UIView {
    
    private var gradientlayer = CAGradientLayer.init()
    
    @IBInspectable open var firstColor: UIColor {
        get {
            if let first = gradientlayer.colors?.first {
                return UIColor.init(cgColor: first as! CGColor)
            }else{
                return UIColor.clear
            }
        }
        set {
            gradientlayer.colors = [newValue.cgColor, lastColor.cgColor]
        }
    }
    @IBInspectable open var lastColor: UIColor {
        get {
            if let last = gradientlayer.colors?.last {
                return UIColor.init(cgColor: last as! CGColor)
            }else{
                return UIColor.clear
            }
        }
        set {
            gradientlayer.colors = [firstColor.cgColor, newValue.cgColor]
        }
    }
    
    @IBInspectable open var firstLocation: CGFloat {
        get {
            return CGFloat(truncating: gradientlayer.locations?.first ?? 0)
        }
        set {
            gradientlayer.locations = [newValue, lastLocation] as [NSNumber]
        }
    }
    @IBInspectable open var lastLocation: CGFloat {
        get {
            return CGFloat(truncating: gradientlayer.locations?.last ?? 1)
        }
        set {
            gradientlayer.locations = [firstLocation, newValue] as [NSNumber]
        }
    }
    @IBInspectable open var startPoint: CGPoint {
        get {
            return gradientlayer.startPoint
        }
        set {
            gradientlayer.startPoint = newValue
        }
    }
    @IBInspectable open var endPoint: CGPoint {
        get {
            return gradientlayer.endPoint
        }
        set {
            gradientlayer.endPoint = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private func setup() {
        firstColor = UIColor.white
        lastColor = UIColor.white
        firstLocation = 0
        lastLocation = 1
        startPoint = CGPoint.init(x: 0.5, y: 0)
        endPoint = CGPoint.init(x: 0.5, y: 1)
        self.layer.addSublayer(gradientlayer)
        
        gradientlayer.frame = self.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientlayer.frame = self.bounds
    }
    
}
