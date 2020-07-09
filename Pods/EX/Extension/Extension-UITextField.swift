//
//  Extension-UITextField.swift
//  iVCoin
//
//  Created by ayong on 2017/11/29.
//  Copyright © 2017年 阿勇. All rights reserved.
//

import UIKit


// MARK: - leftView & rightView
extension UITextField {
    //MARK: - 设置UITextField的leftView
    /// 设置 leftView
    ///
    /// - Parameters:
    ///   - imageName: image name
    ///   - width: width
    ///   - height: height
    @available(*, deprecated, renamed: "setLeftImg(_:width:height:)")
    public func aySetLeftImageView(_ imageName: String, width: CGFloat = 30, height: CGFloat = 44) {
        self.setLeftImg(imageName, width: width, height: height)
    }
    
    //MARK: - 设置UITextField的rightView
    /// 设置UITextField的rightView
    ///
    /// - Parameters:
    ///   - imageName: image name
    ///   - width: width
    ///   - height: height
    @available(*, deprecated, renamed: "setRightImg(_:width:height:)")
    public func aySetRightImageView(_ imageName: String, width: CGFloat = 30, height: CGFloat = 44) {
        self.setRightImg(imageName, width: width, height: height)
    }
    
    //MARK: - 设置UITextField的rightView
    /// 设置UITextField的rightView
    ///
    /// - Parameters:
    ///   - normalImageName: normal image name
    ///   - width: width
    ///   - height: height
    /// - Returns: 返回rightView
    @available(*, deprecated, renamed: "setRightButton(_:width:height:)")
    public func aySetRightButton(_ normalImageName: String, width: CGFloat = 30, height: CGFloat = 44) -> UIButton {
        return self.setRightButton(normalImageName, width: width, height: height)
    }
    
    /// --------------------------leftView & rightView 调整新的api名称--------------------------
    
    //MARK: - 设置UITextField的leftView
    /// 设置 leftView
    ///
    /// - Parameters:
    ///   - imageName: image name
    ///   - width: width
    ///   - height: height
    public func setLeftImg(_ imageName: String, width: CGFloat = 30, height: CGFloat = 44) {
        let uLeftView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        uLeftView.image = UIImage.init(named: imageName)
        uLeftView.contentMode = .center
        self.leftView = uLeftView
        self.leftViewMode = .always
    }
    
    //MARK: - 设置UITextField的rightView
    /// 设置UITextField的rightView
    ///
    /// - Parameters:
    ///   - imageName: image name
    ///   - width: width
    ///   - height: height
    public func setRightImg(_ imageName: String, width: CGFloat = 30, height: CGFloat = 44) {
        let uRightView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        uRightView.image = UIImage.init(named: imageName)
        uRightView.contentMode = .center
        self.rightView = uRightView
        self.rightViewMode = .always
    }
    
    //MARK: - 设置UITextField的rightView
    /// 设置UITextField的rightView
    ///
    /// - Parameters:
    ///   - normalImageName: normal image name
    ///   - width: width
    ///   - height: height
    /// - Returns: 返回rightView
    public func setRightButton(_ normalImageName: String, width: CGFloat = 30, height: CGFloat = 44) -> UIButton {
        let uRightView = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        uRightView.setImage(UIImage.init(named: normalImageName), for: .normal)
        uRightView.contentMode = .center
        self.rightView = uRightView
        self.rightViewMode = .always
        
        return uRightView
    }
}
