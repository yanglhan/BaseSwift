//
//  Extension-UINavigationBar.swift
//  iVCoin
//
//  Created by Tyler.Yin on 2017/11/30.
//  Copyright © 2017年 阿勇. All rights reserved.
//

import UIKit

extension UINavigationBar {
    // MARK: - navbar背景图片用颜色填充
    /// navbar背景图片用颜色填充
    ///
    /// - Parameter color: UIColor
    public func setBackground(_ color: UIColor) {
        self.setBackgroundImage(color.image(scale: 0), for: .any, barMetrics: .default)
    }
    // MARK: - 是否显示navbar的底部阴影效果
    /// 是否显示navbar的底部阴影效果，这个需要配合setBackgroundImage一起使用才有效果
    ///
    /// - Parameter visible: Bool
    public func setShadowVisible(_ visible: Bool) {
        self.shadowImage = visible ? nil : UIImage()
    }
}

extension UINavigationBar {
    public var defaultLargeTitleHeight: CGFloat {
        if #available(iOS 11.0, *) {
            if self.prefersLargeTitles {
                return 52
            }
        }
        return 0
    }
}
