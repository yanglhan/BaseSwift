//
//  Extension-XString.swift
//  DigitalClub
//
//  Created by TEZWEZ on 2019/8/30.
//  Copyright © 2019 tezwez. All rights reserved.
//

extension String {
    var HTMLToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return NSAttributedString()
        }
        
        do {
            return try NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return HTMLToAttributedString?.string ?? ""
    }
}

extension String {
    ///将十六进制颜色转换为UIColor
    public func uiColor(alpha: CGFloat = 1.0) -> UIColor {
        
        var hexColorString = self
        
        if hexColorString.contains("#") {
            hexColorString = String(hexColorString.suffix(6))
        }
        
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
        
        // 分别转换进行转换
        var str = hexColorString[..<hexColorString.index(hexColorString.startIndex, offsetBy: 2)]
        Scanner(string: String(str)).scanHexInt32(&red)
        str = hexColorString[hexColorString.index(hexColorString.startIndex, offsetBy: 2)..<hexColorString.index(hexColorString.startIndex, offsetBy: 4)]
        Scanner(string: String(str)).scanHexInt32(&green)
        str = hexColorString[hexColorString.index(hexColorString.startIndex, offsetBy: 4)..<hexColorString.index(hexColorString.startIndex, offsetBy: 6)]
        Scanner(string: String(str)).scanHexInt32(&blue)
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    ///去首位空格
    public func trimmingWhitespacesAndNewlines() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    ///String类型转Double，1、避免Double(str)失败，2、NumberFormatter处理
    public func toDouble() -> Double {
        guard !self.isEmpty else {
            return 0
        }
        let formater = NumberFormatter.init()
        formater.numberStyle = .decimal
        
        return formater.number(from: self)?.doubleValue ?? 0
    }
    
    ///根据开始位置和长度截取字符串
    public func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
    
    ///String -> Char Array
    func stringToCharArray() -> Array<String> {
        return self.map{String($0)}
    }
    
    ///JSONString -> Array
    func arrayFromJSONString() -> Array<Any>? {
        let jsonData: Data = self.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as? Array
        }
        return nil
    }
    
    ///JSONString -> Dictionary
    func dictionaryFromJSONString() -> Dictionary<String, Any>? {
        let jsonData: Data = self.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as? Dictionary
        }
        return nil
    }
}

extension String{
    func isUrl() -> Bool!{
        if self.contains(NSHomeDirectory()) {
            return true
        }
        let urls = self.lowercased()
        if urls.contains("http://") {
            return true
        }
        
        if urls.contains("https://") {
            return true
        }
        return false
    }
}

extension String{
    /// 行间距
    func spacingText(spacing: CGFloat = 8, font: UIFont, alignment: NSTextAlignment = .left, lineBreakModel: NSLineBreakMode = .byWordWrapping) -> NSMutableAttributedString{
        let attributeText = NSMutableAttributedString.init(string: self, attributes: [NSAttributedString.Key.kern : spacing])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        paragraphStyle.paragraphSpacingBefore = 0
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = lineBreakModel
        attributeText.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.font: font], range: NSMakeRange(0, self.length))
        return attributeText
    }
    
    func adjustAttributeText(width: CGFloat, font: UIFont) -> NSMutableAttributedString{
        var spacing: CGFloat = 0
        
        var textWidth: CGFloat = 0
        var attributeText = NSMutableAttributedString.init(string: self, attributes: [NSAttributedString.Key.kern : spacing])
        textWidth = attributeText.size().width
        while textWidth < width {
            spacing += 1
            attributeText = NSMutableAttributedString.init(string: self, attributes: [NSAttributedString.Key.kern : spacing])
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 0
            paragraphStyle.paragraphSpacingBefore = 0
            paragraphStyle.lineBreakMode = .byWordWrapping
            attributeText.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.font: font], range: NSMakeRange(0, self.length))
            textWidth = attributeText.size().width
        }
        
        return attributeText
    }
}

extension String {
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
     
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}

extension String {
    /// range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    /// NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}

extension String {
    func showEmail() -> String {
        var result = self
        let arr = result.components(separatedBy: "@")
        if arr.count > 1, let last = arr.last, last.count > 0 {
            let pre = arr.first
            if pre?.count ?? 0 > 3 {
                result = pre![..<pre!.index(pre!.startIndex, offsetBy: 3)] + "***@" + last
            }
        }
        return result
    }
    
    func showPhone() -> String {
        if self.count > 6 {
            return self.secureText(location: 3, length: self.count-7)
        }
        return self
    }
}
