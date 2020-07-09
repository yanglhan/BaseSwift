//
//  Extension-NSLayoutConstraint.swift
//  AYSeg
//
//  Created by Tyler.Yin on 2019/2/18.
//

import Foundation
import UIKit
extension NSLayoutConstraint {
    // MARK: - 修改multiplier
    /// 修改multiplier
    ///
    /// - Parameter multiplier: CGFloat
    /// - Returns: NSLayoutConstraint
    @available(*, deprecated, renamed: "setMultiplier(_:)")
    public func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        return setMultiplier(multiplier)
    }
    
    // MARK: - 修改multiplier
    /// 修改multiplier
    ///
    /// - Parameter multiplier: CGFloat
    /// - Returns: NSLayoutConstraint
    public func setMultiplier(_ multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem as Any?,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
