//
//  Extension-UIView.swift
//  iVCoin
//
//  Created by ayong on 2017/11/28.
//  Copyright © 2017年 阿勇. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    //MARK: - 给view添加圆角
    /// 给view添加圆角
    @IBInspectable
    public var ayCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        // also  set(newValue)
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    //MARK: - 给view指定边框宽度
    /// 给view指定边框宽度
    @IBInspectable
    public var ayBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    //MARK: - 给view指定边框颜色
    /// 给view指定边框颜色
    @IBInspectable
    public var ayBorderColor: UIColor? {
        get {
            return UIColor.init(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

// MARK: - 扩展toast功能：上面图片，下面文字
extension UIView {
    // MARK: - 扩展toast功能：上面图片，下面文字
    public func makeToast(_ topImg: UIImage, bottomMSG: String) {
        let toast = UIView.init(frame: CGRect.init(x: (self.frame.width-125)/2, y: (self.frame.height-100)/2-50, width: 125, height: 100))
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        toast.ayCornerRadius = 10
        self.addSubview(toast)
        /*
        toast.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 125, height: 100))
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-50)
        }
        */
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: toast.frame.height-20-15, width: toast.frame.width, height: 20))
        label.text = bottomMSG
        label.font = UIFont.init(name: "PingFangSC-Medium", size: 15)
        label.textColor = UIColor.white
        label.textAlignment = .center
        toast.addSubview(label)
        /*
        label.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-15)
            make.height.equalTo(20)
        }
        */
        let imgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: toast.frame.width, height: toast.frame.height-20-15))
        imgView.image = topImg
        imgView.contentMode = .center
        toast.addSubview(imgView)
        /*
        imgView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(label.snp.top)
        }
        */
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            toast.removeFromSuperview()
        }
    }
}

extension UIView {
    // MARK: - view截图
    /// view截图
    ///
    /// - Parameter scale: scale
    /// - Returns: UIImage?
    public func screenShot(scale: CGFloat = 0) -> UIImage? {
        guard frame.size.height > 0 && frame.size.width > 0 else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension UIButton {
    //MARK: - Button在IB上添加设置标题自适应宽度
    /// Button在IB上添加设置标题自适应宽度
    @IBInspectable
    public var ayAdjustsFontSizeToFitWidth: Bool {
        get {
            return titleLabel?.adjustsFontSizeToFitWidth ?? false
        }
        // also  set(newValue)
        set {
            titleLabel?.adjustsFontSizeToFitWidth = newValue
        }
    }
}

extension UIView {
    // MARK: - 设置阴影
    /// 设置阴影
    ///
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - opacity: 不透明度 0~1
    ///   - offset: 偏移量CGSize
    public func setShadow(color: UIColor = UIColor.black.withAlphaComponent(0.4), offset: CGSize = CGSize.zero, opacity: Float = 0.4, radius: CGFloat = 3) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.clipsToBounds = false
    }
}
