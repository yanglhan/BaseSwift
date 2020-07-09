//
//  Extension-Color.swift
//  BelifData
//
//  Created by ayong on 2017/2/14.
//  Copyright © 2017年 ayong. All rights reserved.
//

import Foundation
import UIKit

extension String {
    // MARK: - 将十六进制颜色转换为UIColor
    /// 将十六进制颜色转换为UIColor
    ///
    /// - Returns: UIColor
    public func uiColor(alpha: CGFloat = 1.0) -> UIColor {
        
        var hexColorString = self
        
        if hexColorString.contains("#") {
            hexColorString = hexColorString[1..<7]
        }
        
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
        
        // 分别转换进行转换
        Scanner(string: hexColorString[0..<2]).scanHexInt32(&red)
        
        Scanner(string: hexColorString[2..<4]).scanHexInt32(&green)
        
        Scanner(string: hexColorString[4..<6]).scanHexInt32(&blue)
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
}


//MARK: 第二种方式是给UIColor添加扩展
extension UIColor {
    // MARK: - 将十六进制颜色转换为UIColor
    /// 将十六进制颜色转换为UIColor
    ///
    /// - Parameters:
    ///   - hex: hex
    ///   - alpha: 0~1
    public convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(hex & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    // MARK: - 用十六进制颜色创建UIColor
    /// 用十六进制颜色创建UIColor
    ///
    /// - Parameter hexColor: 十六进制颜色 (0F0F0F)
    public convenience init(hexColor: String, alpha: CGFloat = 1.0) {
        
        var hexColorString = hexColor
        
        if hexColorString.contains("#") {
            hexColorString = hexColorString[1..<7]
        }
        
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
        
        // 分别转换进行转换
        Scanner(string: hexColorString[0..<2]).scanHexInt32(&red)
        
        Scanner(string: hexColorString[2..<4]).scanHexInt32(&green)
        
        Scanner(string: hexColorString[4..<6]).scanHexInt32(&blue)
        
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
}
extension String {
    
    // MARK: - String使用下标截取字符串， 例: "示例字符串"[0..<2] 结果是 "示例"
    /// String使用下标截取字符串， 例: "示例字符串"[0..<2] 结果是 "示例"
    ///
    /// - Parameter r: range
    public subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            
            return String(self[startIndex..<endIndex])
        }
    }
}



// MARK: - 随机颜色
extension UIColor {
    // MARK: - 随机颜色
    /// 在124~255之间随机，颜色比较温和一点
    ///
    /// - Returns: UIColor
    public static func randColor() -> UIColor {
        return UIColor.init(red: CGFloat(arc4random()%(256-124)+124)/255.0, green: CGFloat(arc4random()%(256-124)+124)/255.0, blue: CGFloat(arc4random()%(256-124)+124)/255.0, alpha: 1)
    }
}


extension UIColor {
    // MARK: - 由颜色填充生成一张图片
    /// 由颜色填充生成一张图片
    ///
    /// - Parameter scale: 缩放因子
    /// - Returns: UIImage
    public func image(scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
