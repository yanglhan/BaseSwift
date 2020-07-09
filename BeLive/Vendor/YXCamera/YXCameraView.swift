//
//  YXCameraView.swift
//  Growdex
//
//  Created by tezwez on 2019/10/15.
//  Copyright © 2019 YUXI. All rights reserved.
//

import Foundation

class YXCameraView: UIView{
    // 扫码区域各种参数
    var viewStyle = YXCameraViewStyle()

    // 扫码区域
    var scanRetangleRect = CGRect.zero
    
    
    // An empty implementation adversely affects performance during animation.
    open override func draw(_ rect: CGRect) {
        drawScanRect()
    }
    
    //MARK: ----- 绘制扫码效果-----
    func drawScanRect() {
        let XRetangleLeft = viewStyle.xScanRetangleOffset
        var sizeRetangle = CGSize(width: frame.size.width - XRetangleLeft * 2.0, height: frame.size.width - XRetangleLeft * 2.0)
        
        if viewStyle.whRatio != 1.0 {
            let w = sizeRetangle.width
            var h = w / viewStyle.whRatio
            h = CGFloat(Int(h))
            sizeRetangle = CGSize(width: w, height: h)
        }
        
        // 扫码区域Y轴最小坐标
        let YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height / 2.0 - viewStyle.centerUpOffset
        let YMaxRetangle = YMinRetangle + sizeRetangle.height
        let XRetangleRight = frame.size.width - XRetangleLeft
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // 非扫码区域半透明
        // 设置非识别区域颜色
        context.setFillColor(viewStyle.color_NotRecoginitonArea.cgColor)
        // 填充矩形
        // 扫码区域上面填充
        var rect = CGRect(x: 0, y: 0, width: frame.size.width, height: YMinRetangle)
        context.fill(rect)

        // 扫码区域左边填充
        rect = CGRect(x: 0, y: YMinRetangle, width: XRetangleLeft, height: sizeRetangle.height)
        context.fill(rect)

        // 扫码区域右边填充
        rect = CGRect(x: XRetangleRight, y: YMinRetangle, width: XRetangleLeft, height: sizeRetangle.height)
        context.fill(rect)

        // 扫码区域下面填充
        rect = CGRect(x: 0, y: YMaxRetangle, width: frame.size.width, height: frame.size.height - YMaxRetangle)
        context.fill(rect)
        // 执行绘画
        context.strokePath()
        
        if viewStyle.isNeedShowRetangle {
            // 中间画矩形(正方形)
            context.setStrokeColor(viewStyle.colorRetangleLine.cgColor)
            context.setLineWidth(1)
            context.addRect(CGRect(x: XRetangleLeft, y: YMinRetangle, width: sizeRetangle.width, height: sizeRetangle.height))

            // CGContextMoveToPoint(context, XRetangleLeft, YMinRetangle);
            // CGContextAddLineToPoint(context, XRetangleLeft+sizeRetangle.width, YMinRetangle);

            context.strokePath()
        }

        scanRetangleRect = CGRect(x: XRetangleLeft, y: YMinRetangle, width: sizeRetangle.width, height: sizeRetangle.height)
        
        
        // 画矩形框4格外围相框角

        // 相框角的宽度和高度
        let wAngle = viewStyle.photoframeAngleW
        let hAngle = viewStyle.photoframeAngleH

        // 4个角的 线的宽度
        let linewidthAngle = viewStyle.photoframeLineW // 经验参数：6和4

        // 画扫码矩形以及周边半透明黑色坐标参数
        var diffAngle = linewidthAngle / 3
        diffAngle = linewidthAngle / 2 // 框外面4个角，与框有缝隙
        diffAngle = linewidthAngle / 2 // 框4个角 在线上加4个角效果
        diffAngle = 0 // 与矩形框重合
        
        switch viewStyle.photoframeAngleStyle {
        case .Outer: diffAngle = linewidthAngle / 3 // 框外面4个角，与框紧密联系在一起
        case .On: diffAngle = 0
        case .Inner: diffAngle = -viewStyle.photoframeLineW / 2
        }
        
        context.setStrokeColor(viewStyle.colorAngle.cgColor)
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        // Draw them with a 2.0 stroke width so they are a bit more visible.
        context.setLineWidth(linewidthAngle)
        
        
        //
        let leftX = XRetangleLeft - diffAngle
        let topY = YMinRetangle - diffAngle
        let rightX = XRetangleRight + diffAngle
        let bottomY = YMaxRetangle + diffAngle

        // 左上角水平线
        context.move(to: CGPoint(x: leftX - linewidthAngle / 2, y: topY))
        context.addLine(to: CGPoint(x: leftX + wAngle, y: topY))
        
        // 左上角垂直线
        context.move(to: CGPoint(x: leftX, y: topY - linewidthAngle / 2))
        context.addLine(to: CGPoint(x: leftX, y: topY + hAngle))
        
        // 左下角水平线
        context.move(to: CGPoint(x: leftX - linewidthAngle / 2, y: bottomY))
        context.addLine(to: CGPoint(x: leftX + wAngle, y: bottomY))
        
        // 左下角垂直线
        context.move(to: CGPoint(x: leftX, y: bottomY + linewidthAngle / 2))
        context.addLine(to: CGPoint(x: leftX, y: bottomY - hAngle))

        // 右上角水平线
        context.move(to: CGPoint(x: rightX + linewidthAngle / 2, y: topY))
        context.addLine(to: CGPoint(x: rightX - wAngle, y: topY))
        
        // 右上角垂直线
        context.move(to: CGPoint(x: rightX, y: topY - linewidthAngle / 2))
        context.addLine(to: CGPoint(x: rightX, y: topY + hAngle))

        // 右下角水平线
        context.move(to: CGPoint(x: rightX + linewidthAngle / 2, y: bottomY))
        context.addLine(to: CGPoint(x: rightX - wAngle, y: bottomY))

        // 右下角垂直线
        context.move(to: CGPoint(x: rightX, y: bottomY + linewidthAngle / 2))
        context.addLine(to: CGPoint(x: rightX, y: bottomY - hAngle))
        
        context.strokePath()
    }
    
    // 根据矩形区域，获取识别区域
    static func getScanRectWithPreView(preView: UIView, style: YXCameraViewStyle) -> CGRect {
        let XRetangleLeft = style.xScanRetangleOffset
        let width = preView.frame.size.width - XRetangleLeft * 2
        let height = width
        var sizeRetangle = CGSize(width: width, height: height)

        if style.whRatio != 1 {
            let w = sizeRetangle.width
            var h = w / style.whRatio

            let hInt: Int = Int(h)
            h = CGFloat(hInt)

            sizeRetangle = CGSize(width: w, height: h)
        }

        // 扫码区域Y轴最小坐标
        let YMinRetangle = preView.frame.size.height / 2.0 - sizeRetangle.height / 2.0 - style.centerUpOffset
        // 扫码区域坐标
        let cropRect = CGRect(x: XRetangleLeft, y: YMinRetangle, width: sizeRetangle.width, height: sizeRetangle.height)

        // 计算兴趣区域
        var rectOfInterest: CGRect

        // ref:http://www.cocoachina.com/ios/20141225/10763.html
        let size = preView.bounds.size
        let p1 = size.height / size.width

        let p2: CGFloat = 1920.0 / 1080.0 // 使用了1080p的图像输出
        if p1 < p2 {
            let fixHeight = size.width * 1920.0 / 1080.0
            let fixPadding = (fixHeight - size.height) / 2
            rectOfInterest = CGRect(x: (cropRect.origin.y + fixPadding) / fixHeight,
                                    y: cropRect.origin.x / size.width,
                                    width: cropRect.size.height / fixHeight,
                                    height: cropRect.size.width / size.width)

        } else {
            let fixWidth = size.height * 1080.0 / 1920.0
            let fixPadding = (fixWidth - size.width) / 2
            rectOfInterest = CGRect(x: cropRect.origin.y / size.height,
                                    y: (cropRect.origin.x + fixPadding) / fixWidth,
                                    width: cropRect.size.height / size.height,
                                    height: cropRect.size.width / fixWidth)
        }

        return rectOfInterest
    }
}
