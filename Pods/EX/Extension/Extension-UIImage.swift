//
//  Extension-UIImage.swift
//  iVCoin
//
//  Created by Tyler.Yin on 2018/1/7.
//  Copyright © 2018年 阿勇. All rights reserved.
//

import UIKit

extension UIImage {
    
    //MARK: - 重新绘制一张指定大小的图片
    /// 重新绘制一张指定大小的图片(在比例不一致的情况下会变形)
    ///
    /// - Parameter size: pt
    /// - Returns: UIImage
    public func scaleToSize(_ size:CGSize) -> UIImage {
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        // 绘制改变大小的图片
        self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        // 从当前context中创建一个改变大小后的图片
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片
        return img;
    }
}


extension UIImage {
    //MARK: - 获取图片的某个部分
    /// - 获取图片的某个部分
    ///
    /// - Parameter rect: 指定截取的frame
    /// - Returns: UIImage
    public func partial(to rect: CGRect) -> UIImage? {
        let x = rect.origin.x*self.scale
        let y = rect.origin.y*self.scale
        let w = rect.size.width*self.scale
        let h = rect.size.height*self.scale
        let r = CGRect.init(x: x, y: y, width: w, height: h)
        
        if let cgImgCropped = self.cgImage?.cropping(to: r) {
            return UIImage.init(cgImage: cgImgCropped, scale: self.scale, orientation: self.imageOrientation)
        }
        return nil
    }
}

extension UIImage {
    // MARK: - 根据颜色渲染图片颜色
    /// 根据颜色渲染图片颜色
    ///
    /// - Parameters:
    ///   - tintColor: 指定
    ///   - blendMode: CGBlendMode
    ///   - alpha: CGFloat
    /// - Returns: UIImage
    public func rendering(tintColor: UIColor, blendMode: CGBlendMode = .destinationIn, alpha: CGFloat = 1) -> UIImage? {
        //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        tintColor.setFill()
        let bounds = CGRect.init(origin: CGPoint.zero, size: self.size)
        UIRectFill(bounds)
        
        //Draw the tinted image in context
        self.draw(in: bounds, blendMode: blendMode, alpha: alpha)
        
        if blendMode != .destinationIn {
            self.draw(in: bounds, blendMode: blendMode, alpha: alpha)
        }
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
    
//    public func gradient(tintColor: UIColor) -> UIImage? {
//        return self.rendering(tintColor: tintColor, blendMode: .overlay)
//    }
    
}
