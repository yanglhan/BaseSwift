//
//  File.swift
//  DigitalClub
//
//  Created by tezwez on 2019/9/10.
//  Copyright © 2019 tezwez. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice{
    
    var isBeforeIOS11: Bool{
        return UIDevice.current.systemVersion.toDouble() < 11
    }
    
    var isAfterIOS11: Bool{
        return UIDevice.current.systemVersion.toDouble() >= 11
    }
    
    public var isLiuhai: Bool {
        if #available(iOS 11, *) {
            guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                return false
            }
            
            if unwrapedWindow.safeAreaInsets.bottom > 0 {
                print(unwrapedWindow.safeAreaInsets)
                return true
            }
        }
        return false
    }
}
