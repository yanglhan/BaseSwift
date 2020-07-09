//
//  AYAdapterLayoutConstraint.swift
//  BmaxWallet
//
//  Created by tezwez on 2019/6/19.
//  Copyright © 2019 tezwez. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint{
    
    @IBInspectable public var adaptPX: CGFloat {
        set {
            if isLiuHaiScreen {
                self.constant = newValue
            }
        }
        get {
            return self.constant
        }
    }
    
    @IBInspectable public var adaptP5S: CGFloat {
        set {
            if UIScreen.main.bounds.size.width == 320 {
                self.constant = newValue
            }
        }
        get {
            return self.constant
        }
    }
}
