//
//  Extension-XImage.swift
//  DigitalClub
//
//  Created by TEZWEZ on 2019/8/30.
//  Copyright © 2019 tezwez. All rights reserved.
//

extension UIImage {
    
    ///重新绘制一张指定大小的图片
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
    
    public func gradient(tintColor: UIColor) -> UIImage? {
        return self.rendering(tintColor: tintColor, blendMode: .overlay)
    }
}
