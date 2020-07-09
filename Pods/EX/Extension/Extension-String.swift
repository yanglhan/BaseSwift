//
//  Extension-String.swift
//  ayong
//
//  Created by ayong on 2017/3/9.
//
//

import Foundation
import UIKit


// MARK: - 返回String的长度length
extension String {
    // MARK: - string的长度
    /// string的长度
    public var length: Int {return self.count}
}


// MARK: - 正则
extension String {
    // MARK: - 正则大陆手机号码
    /// 正则大陆手机号码
    ///
    /// - Returns: 返回匹配结果
    public func isTelNumber() -> Bool {
        let mobile = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"
        let  CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
        let  CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
        let  CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: self) == true)
            || (regextestcm.evaluate(with: self)  == true)
            || (regextestct.evaluate(with: self) == true)
            || (regextestcu.evaluate(with: self) == true)) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - 正则验证通用方法,rule为正则
    /// 正则函数
    ///
    /// - Parameter rule: 正则表达式
    /// - Returns: 返回匹配结果
    public func validate(rule: String) -> Bool {
        let regex = rule
        let test:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
    
    // MARK: - 邮箱验证
    /// 邮箱验证
    ///
    /// - Returns: 返回验证结果
    public func validateEmail(rule: String = "^([a-zA-Z0-9]+[_|\\-|\\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\\-|\\.]?)*[a-zA-Z0-9]+(\\.[a-zA-Z]{2,3})+$") -> Bool {
        let emailRegex = rule
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    // MARK: - 密码验证（默认值为：密码为8~20位，必须包括字母数字）
    /// 密码验证（密码为8~20位，必须包括字母数字）
    ///
    /// - Returns: <#return value description#>
    public func validatePassword(rule: String = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$") -> Bool {
        let regex = rule
        let test:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
}






// MARK: - 汉字处理
extension String {
    // MARK: - 汉字 -> 拼音
    /// 汉字 -> 拼音
    ///
    /// - Returns: 返回拼音
    public func chineseToPinyin() -> String {
        
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false)
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = stringRef as String
        
        return pinyin
    }
    
    // MARK: - 判断是否含有中文
    /// 判断是否含有中文
    ///
    /// - Returns: 返回判断结果
    public func isIncludeChineseIn() -> Bool {
        
        for (_, value) in self.enumerated() {
            
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - 获取第一个字符
    /// 获取第一个字符
    ///
    /// - Returns: 返回第一个字符
    public func first() -> String {
        return String(self.prefix(1))
    }
    
}


extension String {
    // MARK: - 根据开始位置和长度截取字符串
    /// 获取子串
    ///
    /// - Parameters:
    ///   - start: 开始位置（location）
    ///   - length: 需要截取的长度
    /// - Returns: 返回截取后的子串
    public func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
}
extension String {
    // MARK: - 强制指定需要多少位小数，不够小数位的补0（方法支持到20位小数，常用够用了，如需更多位小数请自行修改）
    /// 强制指定需要多少位小数，不够小数位的补0（方法支持到20位小数，常用够用了，如需更多位小数请自行修改）
    ///
    /// - Parameter digits: 小数位数
    /// - Returns: 返回转换化后的结果
    @available(*, deprecated, renamed: "decimal(forceDigits:)")
    public func forceDecimalDigits(_ digits: Int) -> String {
        guard digits >= 0, digits <= 20 else {
            return self
        }
        return self.decimal(forceDigits: UInt(digits))
    }
    
    // MARK: - 强制指定需要多少位小数，不够小数位的补0
    /// 强制指定需要多少位小数，不够小数位的补0
    ///
    /// - Parameter digits: 小数位数
    /// - Returns: 返回转换化后的结果
    public func decimal(forceDigits: UInt) -> String {
        guard Double(self) != nil else {
            return self
        }
        
        var str = ""
        for _ in 0..<forceDigits {
            str.append("0")
        }
        if !self.contains(".") {
            return self + "." + str.subString(start: 0, length: Int(forceDigits))
        }
        let arr = self.components(separatedBy: ".")
        
        return arr[0] + "." + (arr[1] + str).subString(start: 0, length: Int(forceDigits))
    }
}

extension String {
    // MARK: - 隐藏部分内容，用*代替(常用场景：银行卡，手机号，证件号码等)
    /// 隐藏部分内容，用*代替(常用场景：银行卡，手机号，证件号码等)
    ///
    /// - Parameters:
    ///   - location: 开始位置
    ///   - length: 需要替换的长度
    /// - Returns: 返回替换后的字串
    public func secureText(location: Int, length: Int) -> String {
        guard location < self.count, length > 0, (location+length) < self.length else {
            return self
        }
        return self.replacingCharacters(in: Range.init(NSRange.init(location: location, length: length), in: self)!, with: String.init(repeating: "*", count: length))
    }
    // MARK: - 指定多少位字符在一起，后面空格间隔开（常用场景：4位放一起的银行卡号）
    /// 指定多少位字符在一起，后面空格间隔开（常用场景：4位放一起的银行卡号）
    ///
    /// - Parameter length:位数
    /// - Returns: Result
    public func togetherLength(_ length: Int) -> String {
        guard length < self.length else {
            return self
        }
        var tmpStr = self
        var arr: [String] = []
        while tmpStr.length > length {
            arr.append(tmpStr.subString(start: 0, length: length))
            tmpStr = tmpStr.subString(start: length)
        }
        if tmpStr.length > 0 {//不够位数，另起一组
            arr.append(tmpStr)
        }
        return arr.componentsJoined(by: " ")
    }
    // MARK: - 银行卡号显示前后各3位，中间部分隐藏，然后从前到后4位放一起，空格间隔开
    /// 银行卡号显示前后各3位，中间部分隐藏，然后从前到后4位放一起，空格间隔开
    ///
    /// - Returns: eg: 612***********888
    public func bankCardSecureText() -> String {
        guard self.validate(rule: "^[0-9]*$") else {
            return self
        }
        return self.replacingOccurrences(of: " ", with: "").secureText(location: 3, length: self.length-6).togetherLength(4)
    }
}


extension String {
    //MARK: - Range转换为NSRange
    /// Range转换为NSRange
    ///
    /// - Parameter range: range
    /// - Returns: NSRange
    public func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
    
    //MARK: - Range转换为NSRange
    /// Range转换为NSRange
    ///
    /// - Parameter nsRange: nsRange
    /// - Returns: Range
    public func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location,
                                     limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length,
                                   limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}



extension String {
    //MARK: - 判断是否是图片名称(暂时只加入了几个常用的格式，待扩展)
    /// 判断是否是图片名称(暂时只加入了几个常用的格式，待扩展)
    ///
    /// - Returns: Result
    public func isPicName() -> Bool {
        return self.validate(rule: "^(.+?)\\.(png|jpg|jpeg|gif)$")
    }
    
    //MARK: - htmlString修改img，video等标签的宽高
    ///
    /// - Parameters:
    ///   - elem: img, video；注意：传参不需要带"<"字符，否则可能得不到预期结果
    ///   - width: 绝对值如375,或者图片百分比如100%
    ///   - height: 跟width类似
    /// - Returns: 修改后的结果
    public func htmlStringElements(_ elem: String, width: String? = nil, height: String? = nil) -> String {
        guard self.contains(elem) else {
            return self
        }
        guard let regex2 = try? NSRegularExpression.init(pattern: "<\(elem)(.*?)>", options: NSRegularExpression.Options.caseInsensitive) else {
            return self
        }
        let array2 = regex2.matches(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange.init(location: 0, length: self.length))
        var dic: [String : String] = [:]
        for b in array2 {
            var str1 = self.subString(start: b.range.location, length: b.range.length)
            let oldValue = str1
            str1 = str1.modifyProperty(elem, property: "height", value: height)
            str1 = str1.modifyProperty(elem, property: "width", value: width)
            let newValue = str1
            if oldValue != newValue {
                dic[oldValue] = newValue
            }
        }
        
        var result = self
        for (oldValue, newValue) in dic {
            result = result.replacingOccurrences(of: oldValue, with: newValue)
        }
        
        
        return result
    }
    //上面方法的helper
    fileprivate func modifyProperty(_ elem: String, property: String, value: String?) -> String {
        if self.contains(property) {
            let range = self.nsRange(from: self.range(of: property)!)!
            let tStr = self.subString(start: range.location)
            var arr = tStr.components(separatedBy: "\"")
            //修改width的值
            if value == nil {
                //删除 "width"
                arr.removeFirst()
                //删除 width对应的值
                arr.removeFirst()
            }else{
                arr.remove(at: 1)
                arr.insert(value!, at: 1)
            }
            //重新组装拆分的数据(前半段拼接上去修改width信息的后半段)
            return self.subString(start: 0, length: range.location) + (arr as NSArray).componentsJoined(by: "\"")
        }else if value != nil {
            let range = self.nsRange(from: self.range(of: elem)!)!
            var result = self
            result.insert(contentsOf: " \(property)=\"\(value!)\"", at: self.index(self.startIndex, offsetBy: range.location+range.length))
            return result
        }
        return self
    }
}

extension String {
    //MARK: - 是否成年
    /// - 是否成年（18）
    ///
    /// - Returns: 是否成年
    public func isAdult() -> Bool {
        guard self.length == 10 else {
            return false
        }
        let arr1 = self.components(separatedBy: "-")
        guard arr1.count == 3 else {
            return false
        }
        guard let year1 = Int(arr1[0]) else {
            return false
        }
        guard let month1 = Int(arr1[1]) else {
            return false
        }
        guard let day1 = Int(arr1[2]) else {
            return false
        }
        
        let fm = DateFormatter.init()
        fm.dateFormat = "yyyy-MM-dd"
        let nowStr = fm.string(from: Date.init())
        let arr2 = nowStr.components(separatedBy: "-")
        
        let year2 = Int(arr2[0])!
        let month2 = Int(arr2[1])!
        let day2 = Int(arr2[2])!
        
        if year2-year1 < 18 {
            return false
        }else if year2-year1 == 18 {//年份刚好18，需要判断月份
            if month2 < month1 {
                return false
            }else if month2 == month1{//月份也满足条件，需要判断日期
                if day2 < day1 {
                    return false
                }
            }
        }
        
        
        return true
    }
}

extension String {
    // MARK: - 去掉首尾空格和换行符
    /// 去掉首尾空格和换行符
    ///
    /// - Returns: Result
    @available(*, deprecated, renamed: "trim(in:)")
    public func trimmingWhitespacesAndNewlines() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    // MARK: - trim
    /// trim
    ///
    /// - Parameter set: CharacterSet, set默认值为whitespacesAndNewlines(去掉首尾的空格和换行符)
    /// - Returns: trim后的结果
    public func trim(in set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        return self.trimmingCharacters(in: set)
    }
}


extension String {
    
    // MARK: - 直接由string名称转换成UIKeyboardType类型
    /// 直接由string名称转换成UIKeyboardType类型
    ///
    /// - Returns: 返回UIKeyboardType
    public func keyboarType() -> UIKeyboardType {
        /*
         case `default` // Default type for the current input method.
         
         case asciiCapable // Displays a keyboard which can enter ASCII characters
         
         case numbersAndPunctuation // Numbers and assorted punctuation.
         
         case URL // A type optimized for URL entry (shows . / .com prominently).
         
         case numberPad // A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN entry.
         
         case phonePad // A phone pad (1-9, *, 0, #, with letters under the numbers).
         
         case namePhonePad // A type optimized for entering a person's name or phone number.
         
         case emailAddress // A type optimized for multiple email address entry (shows space @ . prominently).
         
         @available(iOS 4.1, *)
         case decimalPad // A number pad with a decimal point.
         
         @available(iOS 5.0, *)
         case twitter // A type optimized for twitter text entry (easy access to @ #)
         
         @available(iOS 7.0, *)
         case webSearch // A default keyboard type with URL-oriented addition (shows space . prominently).
         
         @available(iOS 10.0, *)
         case asciiCapableNumberPad // A number pad (0-9) that will always be ASCII digits.
         */
        switch self.lowercased() {
        case "asciiCapable".lowercased():
            return .asciiCapable
        case "numbersAndPunctuation".lowercased():
            return .numbersAndPunctuation
        case "URL".lowercased():
            return .URL
        case "numberPad".lowercased():
            return .numberPad
        case "phonePad".lowercased():
            return .phonePad
        case "namePhonePad".lowercased():
            return .namePhonePad
        case "emailAddress".lowercased():
            return .emailAddress
        case "decimalPad".lowercased():
            return .decimalPad
        case "twitter".lowercased():
            return .twitter
        case "webSearch".lowercased():
            return .webSearch
        case "asciiCapableNumberPad".lowercased():
            if #available(iOS 10.0, *) {
                return .asciiCapableNumberPad
            } else {
                return .asciiCapable
            }
        default:
            return .default
        }
    }
}
