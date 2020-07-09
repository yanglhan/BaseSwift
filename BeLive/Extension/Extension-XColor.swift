//
//  Extension-UIColor.swift
//  DigitalClub
//
//  Created by TEZWEZ on 2019/8/30.
//  Copyright © 2019 tezwez. All rights reserved.
//

import UIKit
import EX

//app使用的所有颜色
extension UIColor {
    static let colord9d9d9 = "#d9d9d9".uiColor()
    static let color777777 = "#777777".uiColor()
    static let colorf2f2f2 = "#f2f2f2".uiColor()
    static let color282828 = "#282828".uiColor()
    static let color333333 = "#333333".uiColor()
    static let color666666 = "#666666".uiColor()
    static let color888888 = "#888888".uiColor()
    static let color999999 = "#999999".uiColor()
    static let color181818 = "#181818".uiColor()
    static let color9e9e9e = "#9e9e9e".uiColor()
    static let colorE12C2C = "#E12C2C".uiColor()
    static let color8995D3 = "#8995D3".uiColor()
    static let colorF5F5F8 = "#F5F5F8".uiColor()
    
    static let color555555 = "#555555".uiColor()
    
    //主题色
    static var theme: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#1A1F33".uiColor() : "#385CAD".uiColor()
        }
    }
    //区域颜色
    static var area: UIColor {//区域底色、反白文字颜色
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#1A1F33".uiColor() : "#FFFFFF".uiColor()
        }
    }
    //顶部导航栏bar tint
    static let navBarTintColor = UIColor.clear
    //顶部导航栏背景
    static var navBarBGColor: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#1A1F33".uiColor() : "#385CAD".uiColor()
        }
    }
    //底部导航栏tint
    static var tabTintColor: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#385CAD".uiColor() : "#385CAD".uiColor()
        }
    }
    static var tabNormalTextColor: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#B3C3DD".uiColor() : "#B3C3DD".uiColor()
        }
    }
    //底部导航栏背景色
    static var tabBarBG: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? .white : .white
        }
    }
    //tableView的背景色
    static var tableViewBG: UIColor {//背景底色
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#111522".uiColor() : "#EFEFF8".uiColor()
        }
    }
    //viewBG
    static var viewBG: UIColor {//背景底色
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#111522".uiColor() : "#EFEFF8".uiColor()
        }
    }
    //文字 颜色
    static var text1: UIColor {//一级标题、文字输入效果
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#FFFFFF".uiColor() : "#1A1F33".uiColor()
        }
    }
    static var text2: UIColor {//二级标题、正文文字颜色
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#EFEFF8".uiColor() : UIColor.color555555
        }
    }
    static var text3: UIColor {//三级标题、辅助文字颜色
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#889DBF".uiColor() : "#889DBF".uiColor()
        }
    }
    static var text4: UIColor {//辅助文字颜色
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#889DBF".uiColor() : "#9A9A9A".uiColor()
        }
    }
    static var highlightText: UIColor {//特殊文字
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#EFEFF8".uiColor() : "#385CAD".uiColor()
        }
    }
    
    //分割线
    static var cellSeparator: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#EFEFF8".uiColor() : "#EFEFF8".uiColor()
        }
    }
    //输入框
    static var inputTextColor: UIColor {//输入框文字颜色、其他文字颜色
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#B3C3DD".uiColor() : "#B3C3DD".uiColor()
        }
    }
    static var inputBgColor: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#111522".uiColor() : "#F5F5F8".uiColor()
        }
    }
    static let inputPlaceholder = UIColor.gray.withAlphaComponent(0.7)
    
    
    static var h1: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? UIColor.theme : UIColor.theme
        }
    }
    static var h2: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? UIColor.theme : UIColor.theme
        }
    }
    static var h3: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? UIColor.theme : UIColor.theme
        }
    }
    static var h4: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? UIColor.theme : UIColor.theme
        }
    }
    static var h5: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#889DBF".uiColor() : "#889DBF".uiColor()
        }
    }
    
    //交易页面
    static var GEntrustCell_VolLabel1_TextColor: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#9A9A9A".uiColor() : "#9A9A9A".uiColor()
        }
    }
    static var GEntrustCell_StatusButton_BackgroundColor: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#EAEEF7".uiColor() : "#EAEEF7".uiColor()
        }
    }
    static var Trade_Slider_Border_Color: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#D8E2F2".uiColor() : "#D8E2F2".uiColor()
        }
    }
    static var Trade_Slider_Circle_Color: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? UIColor.white : UIColor.white
        }
    }
    static var Trade_Slider_Buy_Color: UIColor {
        get {
            return UIColor.klineRiseColor
        }
    }
    static var Trade_Slider_Sell_Color: UIColor {
        get {
            return UIColor.klineFallColor
        }
    }
    static let Trade_Slider_Thumb_Color_Green = "#97EBCB".uiColor()
    static let Trade_Slider_Thumb_Color_Red = "#F4C9C9".uiColor()
    static var Trade_Slider_Thumb_Buy: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.cnKLineStyle) ? Trade_Slider_Thumb_Color_Red : Trade_Slider_Thumb_Color_Green
        }
    }
    static var Trade_Slider_Thumb_Sell: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.cnKLineStyle) ? Trade_Slider_Thumb_Color_Green : Trade_Slider_Thumb_Color_Red
        }
    }
    static var ActionSheet_Normal_Color: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#B3C3DD".uiColor() : "#B3C3DD".uiColor()
        }
    }
    static var ActionSheet_Selected_Color: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? UIColor.h2 : UIColor.h2
        }
    }
    
    
    // 等级黄色
    static let levelYellowColor = "#FFB205".uiColor()
    
    ///由颜色填充生成一张图片
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

public extension UIColor {
    /// Return a instance of UIColor, which corresponding to hex RGB value
    ///
    /// - Parameter rgb: hex rgb value, like `0xFFFFFF`
    convenience init(rgb: UInt32) {
        let rgba = rgb << 8 | 0x000000FF
        
        self.init(rgba: rgba)
    }
    
    /// Return a instance of UIColor, which corresponding to hex RGBA value
    ///
    /// - Parameter rgba: hex rgb value, like `0xFFFFFFFF`
    convenience init(rgba: UInt32) {
        let red = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let blue = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let alpha = CGFloat(rgba & 0x000000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

//K线颜色
extension UIColor {
    static let redKLine = "#FF5858".uiColor()
    static let greenKLine = "#1DCE8A".uiColor()
    static let redDepthBG = "#39283A".uiColor()
    static let greenDepthBG = "#103B43".uiColor()
    static var klineRiseColor: UIColor {
        get {
            //cnKLineStyle红涨绿跌
            return Storage.boolValue(key: Storage.Name.cnKLineStyle) ? redKLine : greenKLine
        }
    }
    static var klineFallColor: UIColor {
        get {
            //cnKLineStyle红涨绿跌
            return Storage.boolValue(key: Storage.Name.cnKLineStyle) ? greenKLine : redKLine
        }
    }
    
    static var klineDepthRiseColor: UIColor {
        get {
            //cnKLineStyle红涨绿跌
            return Storage.boolValue(key: Storage.Name.cnKLineStyle) ? redDepthBG : greenDepthBG
        }
    }
    static var klineDepthFallColor: UIColor {
        get {
            //cnKLineStyle红涨绿跌
            return Storage.boolValue(key: Storage.Name.cnKLineStyle) ? greenDepthBG : redDepthBG
        }
    }
    
    /// 选中高亮效果(蓝色)
    static var selectedBtnColor: UIColor {
        get {
            return Storage.boolValue(key: Storage.Name.darkAppStyle) ? "#4773BA".uiColor() : "#4773BA".uiColor()
        }
    }
    
    /// 顶部颜色（包括导航栏）
    static var KLine_NavBG: UIColor {
        get {
            return "#131F30".uiColor()
        }
    }
    
    /// 整体背景颜色
    static var KLine_Main_BG: UIColor {
        get {
            return "#081724".uiColor()
        }
    }
    /// 底部买卖按钮底部背景颜色
    static var KLine_BottomBtnsBGVBG: UIColor {
        get {
            return "#172841".uiColor()
        }
    }
    
    
    /// depth buy填充颜色
    static var KLine_Depth_Rise_Fill: UIColor {
        get {
            return klineDepthRiseColor
        }
    }
    
    /// depth buy 边颜色
    static var KLine_Depth_Buy_Stroke: UIColor {
        get {
            return klineRiseColor
        }
    }

    
    /// depth sell填充颜色
    static var KLine_Depth_Sell_Fill: UIColor {
        get {
            return klineDepthFallColor
        }
    }
    
    /// depth sell 边颜色
    static var KLine_Depth_Sell_Stroke: UIColor {
        get {
            return klineFallColor
        }
    }


    
    /// 选择面板背景色
    static var KLine_Select_Board: UIColor {
        get {
            return "#0E1B2B".uiColor()
        }
    }
    
    /// 导航栏返回键后面的分割线
    static var KLine_Nav_Symbol_Line: UIColor {
        get {
            return "#6D87A8".uiColor()
        }
    }
    
    /// 导航栏rightitem nomal颜色
    static var KLine_Nav_Right_Item_Normal: UIColor {
        get {
            return "#B3C3DD".uiColor()
        }
    }
    
    /// 导航栏rightitem nomal颜色
    static var KLine_Nav_Right_Fav_Item_Selected: UIColor {
        get {
            return "#B3C3DD".uiColor()
        }
    }
    
    /// k线页面选中效果--蓝色
    static var KLine_Btn_Selected: UIColor {
        get {
            return "#385CAD".uiColor()
        }
    }
    
    
    /// k线页面文字颜色
    static var KLine_Text: UIColor {
        get {
            return "#889DBF".uiColor()
        }
    }
    
    /// k线页面更多选中效果
    static var KLine_White_Color: UIColor {
        get {
            return "#CFD3E9".uiColor()
        }
    }
    
    /// k线选中价格显示的背景颜色
    static var KLine_SelectedBoardBG: UIColor {
        get {
            return "#091825".uiColor()
        }
    }
    
    /// k线选中价格显示的背景颜色
    static var KLine_SelectedBoardBGBorder: UIColor {
        get {
            return "#6D87A8".uiColor()
        }
    }
    
    /// k线用户点击选中文字颜色
    static var KLine_SelectedTextColor: UIColor {
        get {
            return "#F5F5F8".uiColor()
        }
    }
    
    /// k线网格线
    static var KLine_Gridlines: UIColor {
        get {
            return "#223349".uiColor()
        }
    }
    
    /// k线页面最高价最低价颜色
    static var KLine_MaxOrMinValue_Text: UIColor {
        get {
            return "#F5F5F8".uiColor()
        }
    }
    
    /// k线-选中价格显示的横线背景颜色
    static var KLine_VerticalLineViewBGColor: UIColor {
        get {
            return "#CFD3E9".uiColor()
        }
    }
    
    /// k线-选中价格显示的竖线背景颜色
    static var KLine_HorizontalLineViewBGColor: UIColor {
        get {
            return UIColor.white
        }
    }
    
    /// ma5
    static var KLine_MA5: UIColor {
        get {
            return "#F4DB92".uiColor()
        }
    }
    /// ma10
    static var KLine_MA10: UIColor {
        get {
            return "#1DCE8A".uiColor()
        }
    }
    /// ma30
    static var KLine_MA30: UIColor {
        get {
            return "#9B72C7".uiColor()
        }
    }
    /// boll
    static var KLine_BOLL: UIColor {
        get {
            return "#F4DB92".uiColor()
        }
    }
    /// boll U
    static var KLine_BOLL_U: UIColor {
        get {
            return "#1DCE8A".uiColor()
        }
    }
    /// boll L
    static var KLine_BOLL_L: UIColor {
        get {
            return "#9B72C7".uiColor()
        }
    }
    /// 时分图
    static var KLine_Timeline: UIColor {
        get {
            return "#1881D3".uiColor()
        }
    }
    /// rsi
    static var KLine_RSI: UIColor {
        get {
            return "#F4DB92".uiColor()
        }
    }
}
