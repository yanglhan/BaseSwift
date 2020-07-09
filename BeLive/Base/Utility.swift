//
//  Utility.swift
//  iVCoin
//
//  Created by YUXI on 2017/12/14.
//  Copyright © 2017年 YUXI. All rights reserved.
//


import Foundation
import UIKit
import Toast_Swift
import KeychainAccess

class Utility {
    /**
     *  获取bundleid
     *
     *  @return bundleid
     */
    class func bundleID() -> String {
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    }
    
    /**
     *  获取内部版本号
     *
     *  @return 内部版本号
     */
    class func getInnerVersion() -> String {
        return (Bundle.main.infoDictionary!["CFBundleVersion"] as! String).components(separatedBy: ".").first!
    }
    
    /**
     *  获取外部版本号
     *
     *  @return 外部版本号
     */
    class func getOutVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    /**
     *  获取内部版本号
     *
     *  @return 内部版本号
     */
    class func getBundleVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
    class func getSystermVersion() -> Double {
        let systemVersion = UIDevice.current.systemVersion
        let version = systemVersion.components(separatedBy: ".").first
        return version!.toDouble()
    }
    
    //获取设备唯一ID（keychain save UUID）
    class func deviceId() ->String {
        let keychain = Keychain(service: bundleID())
        if let deviceId = keychain["k_app_device_id"], !deviceId.isEmpty {
            return deviceId
        } else {
            let uuid = NSUUID.init().uuidString
            keychain["k_app_device_id"] = uuid
            return uuid
        }
    }
}

func showSimpleToast(_ msg: String, complete: ((Bool) -> Void)? = nil) {
    guard msg.length > 0 else {
        return
    }
    if Thread.current.isMainThread {
         UIApplication.shared.keyWindow?.makeToast(msg, duration: 2.0, position: .center, completion: complete)
    }else{
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.makeToast(msg, duration: 2.0, position: .center, completion: complete)
        }
    }
}


func showSimpleAlert(_ title: String? = nil, msg: String? = nil, cancelButtonTitle: String? = nil, vc: UIViewController) {
    let fun = {
//        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
//        alert.addAction(UIAlertAction.init(title: cancelButtonTitle ?? "我知道了".localRegister(key: "I_know"), style: .cancel, handler: nil))
//        vc.present(alert, animated: true, completion: nil)
    }
    if Thread.current.isMainThread {
        fun()
    }else{
        DispatchQueue.main.async {
            fun()
        }
    }
    
}


func validate(rule: String, str: String) -> Bool {
    let regex = rule
    let test:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return test.evaluate(with: str)
}

func validateEmail(email: String) -> Bool {
//    let emailRegex = "^([a-zA-Z0-9]+[_|\\-|\\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\\-|\\.]?)*[a-zA-Z0-9]+(\\.[a-zA-Z]{2,3})+$"
    let emailRegex = "^[A-Za-z\\d]+([-_.][A-Za-z\\d]+)*@([A-Za-z\\d]+[-.])+[A-Za-z\\d]{2,4}$"
    let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: email)
}
func validatePassword(password: String) -> Bool {
    let regex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)[A-Za-z\\d]{6,20}$"
    let test:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return test.evaluate(with: password)
//    return (password.count>5 && password.count<20)
}

func validateSamplePassword(password: String) -> Bool {
    //    let regex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)[A-Za-z\\d]{6,20}$"
    //    let test:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
    //    return test.evaluate(with: password)
    return (password.count>5 && password.count<20)
}

///判断地址有效性
func validateCoinAddress(address: String) -> Bool {
    let regex = "^(?=.*[a-zA-Z])[A-Za-z0-9:]{10,}$"//必须包含字母，可有字母数字以及英文冒号，大于等于10位
    let test:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return test.evaluate(with: address)
}

//let validatePasswordErrorDesc = "请设置6-20位大写字母+小写字母+数字".localRegister(key: "Login_password_rule")

//获取字符串Label宽度
func getLabWidth(labelStr: String, font: UIFont, height:CGFloat) -> CGFloat {
    let statusLabelText: NSString = labelStr as NSString
    let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height)
    let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context: nil).size
    return strSize.width
}
//获取字符串Label高度
func getLabHeight(labelStr: String, font: UIFont, width:CGFloat) -> CGFloat {
    let statusLabelText: NSString = labelStr as NSString
    let size = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
    let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context: nil).size
    return strSize.height
}

func getLabelAdjustFontSize(text: String, width: CGFloat, font defaultFont: UIFont = UIFont.systemFont(ofSize: 15)) -> CGFloat{
    
    var font: UIFont? = defaultFont
    
    let nsText = text as NSString
    var dic = NSDictionary(object: font!, forKey: NSAttributedString.Key.font as NSCopying)
    var textSize = nsText.size(withAttributes: (dic as! [NSAttributedString.Key : Any]))
    while textSize.width > width {
        font = UIFont.init(name: font!.fontName, size: font!.pointSize-1)
        if font == nil {
            UIFont.systemFont(ofSize: font!.pointSize-1)
        }
        dic = NSDictionary(object: font!, forKey: NSAttributedString.Key.font as NSCopying)
        textSize = nsText.size(withAttributes: (dic as! [NSAttributedString.Key : Any]))
        print("getLabelAdjustFontSize")
    }
    
    return font?.pointSize ?? defaultFont.pointSize
}

//字典转JSON字符串
func getJSONStringFromDictionary(dictionary: Dictionary<String, String>) -> String {
    if !JSONSerialization.isValidJSONObject(dictionary) {
        print("转换失败！")
        return ""
    }
    let data: Data = try! JSONSerialization.data(withJSONObject: dictionary, options: []) as Data
    let JSONString = String.init(data: data, encoding: .utf8)
    return JSONString ?? ""
}

//base64 转 UIImage
func base64StringToUIImage(base64String: String) -> UIImage? {
    var str = base64String
    
    // 1、判断用户传过来的base64的字符串是否是以data开口的，如果是以data开头的，那么就获取字符串中的base代码，然后在转换，如果不是以data开头的，那么就直接转换
    if str.hasPrefix("data:image") {
        guard let newBase64String = str.components(separatedBy: ",").last else {
            return nil
        }
        str = newBase64String
    }
    // 2、将处理好的base64String代码转换成NSData
    guard let imgNSData = Data(base64Encoded: str, options: NSData.Base64DecodingOptions()) else {
        return nil
    }
    // 3、将NSData的图片，转换成UIImage
    guard let codeImage = UIImage(data: imgNSData as Data) else {
        return nil
    }
    return codeImage
}

public func GLog<T>(_ fmt: T, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let fileName = NSString(string: file).pathComponents.last!
    print("[Debug_Print: \(fileName) > \(function), \(line)]\n\t\(fmt)")
    #endif
}

