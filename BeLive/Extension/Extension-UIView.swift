//
//  Extension-UIView.swift
//  DigitalClub
//
//  Created by tezwez on 2019/9/3.
//  Copyright © 2019 tezwez. All rights reserved.
//

import Foundation


// MARK: 虚线边框
public struct UIRectSide : OptionSet {
    
    public let rawValue: Int
    
    public static let left = UIRectSide(rawValue: 1 << 0)
    
    public static let top = UIRectSide(rawValue: 1 << 1)
    
    public static let right = UIRectSide(rawValue: 1 << 2)
    
    public static let bottom = UIRectSide(rawValue: 1 << 3)
    
    public static let all: UIRectSide = [.top, .right, .left, .bottom]
    
    let cornerRadius: CGFloat = 10
    
    public init(rawValue: Int) {
        
        self.rawValue = rawValue;
        
    }
    
}

extension UIView{
    
    
    
    ///画虚线边框
    
    func drawDashLine(strokeColor: UIColor, lineWidth: CGFloat = 0.5, lineLength: Int = 2, lineSpacing: Int = 3, corners: UIRectSide) {
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = self.bounds
        
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeColor = strokeColor.cgColor
        
        shapeLayer.lineWidth = lineWidth
        
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        
        
        //每一段虚线长度 和 每两段虚线之间的间隔
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        
        
        
        let path = CGMutablePath()
        
        let cornerRadius = corners.cornerRadius
        
        if corners.contains(.left) {
            
            path.move(to: CGPoint(x: 0, y: self.layer.bounds.height - cornerRadius))
            path.addLine(to: CGPoint(x: 0, y: cornerRadius))
            
            // 左上圆角
            path.addArc(center: CGPoint.init(x: 0 + cornerRadius, y: 0+cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi/2.0*3), clockwise: false)
        }
        
        if corners.contains(.top){
            
            path.move(to: CGPoint(x: cornerRadius, y: 0))
            
            path.addLine(to: CGPoint(x: self.layer.bounds.width-cornerRadius, y: 0))
            
            // 右上圆角
            path.addArc(center: CGPoint.init(x:self.layer.bounds.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi/2.0)*3, endAngle: CGFloat(Double.pi*2), clockwise: false)
        }
        
        if corners.contains(.right){
            
            path.move(to: CGPoint(x: self.layer.bounds.width, y: cornerRadius))
            
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height-cornerRadius))
            
            // 右下圆角
            path.addArc(center: CGPoint.init(x:self.layer.bounds.width - cornerRadius, y:self.layer.bounds.height - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: CGFloat(Double.pi/2.0), clockwise: false)
        }
        
        if corners.contains(.bottom){
            
            path.move(to: CGPoint(x: self.layer.bounds.width-cornerRadius, y: self.layer.bounds.height))
            
            path.addLine(to: CGPoint(x: cornerRadius, y: self.layer.bounds.height))
            
            // 左下圆角
            path.addArc(center: CGPoint.init(x: cornerRadius, y: self.layer.bounds.height-cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi/2.0), endAngle: CGFloat(Double.pi), clockwise: false)
        }
        
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    ///画实线边框
    
    func drawLine(strokeColor: UIColor, lineWidth: CGFloat = 1, corners: UIRectSide) {
        
        
        
        if corners == UIRectSide.all {
            
            self.layer.borderWidth = lineWidth
            
            self.layer.borderColor = strokeColor.cgColor
            
        }else{
            
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.bounds = self.bounds
            
            shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
            
            shapeLayer.fillColor = UIColor.blue.cgColor
            
            shapeLayer.strokeColor = strokeColor.cgColor
            
            
            
            shapeLayer.lineWidth = lineWidth
            
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
            
            
            
            let path = CGMutablePath()
            
            
            
            if corners.contains(.left) {
                
                path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
                
                path.addLine(to: CGPoint(x: 0, y: 0))
                
            }
            
            if corners.contains(.top){
                
                path.move(to: CGPoint(x: 0, y: 0))
                
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
                
            }
            
            if corners.contains(.right){
                
                path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
                
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
                
            }
            
            if corners.contains(.bottom){
                
                path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
                
                path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
                
            }
            
            
            
            shapeLayer.path = path
            
            self.layer.addSublayer(shapeLayer)
            
            
            
        }
        
        
        
    }
    
}


//MARK - 阴影
extension UIView{
    func addShadow(_ border: CGFloat){
        layer.cornerRadius = border
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor(rgb: 0xAFAFAF).cgColor
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}
