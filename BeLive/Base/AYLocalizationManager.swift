//
//  AYLocalizationManager.swift
//  iVCoin
//
//  Created by TEZWEZ on 2019/12/19.
//  Copyright © 2019 YUXI. All rights reserved.
//

import Foundation
//import MJRefresh
import MGFaceIDLiveDetect

let key_localization = "key_localization_key_value"

enum LocalizedFile: String {
    case `default`  = "InfoPlist"
    case main       = "Main"
}

extension Notification.Name {
    static let userLanguage = Notification.Name.init("userLanguage")
    static let settingAppleLanguages = Notification.Name.init("AppleLanguages")
}

class AYLocalizationManager {
    static let shared = AYLocalizationManager.init()
    #if DEBUG
//    fileprivate(set) var allKeyAndValue: [String : String] = [:]
    fileprivate(set) var allKeyAndValue: [String : String] = (UserDefaults.standard.dictionary(forKey: key_localization) as? [String : String]) ?? [:]
    #endif
    
    private(set) var bundle = Bundle.init(path: Bundle.main.path(forResource: AYLocalizationManager.userLang(), ofType: "lproj") ?? Bundle.main.path(forResource: "en", ofType: "lproj")!)!
    
    private init() {
    }
    
    static func userLang() -> String {
        var result = "en"
        if let ul = UserDefaults.standard.string(forKey: Notification.Name.userLanguage.rawValue) {
            result = ul
        } else {
            let current = Locale.preferredLanguages.first!
            if current.hasPrefix("zh-Hans") {
                result = "zh-Hans"
            } else if current.hasPrefix("zh-Hant") {
                result = "zh-Hant"
            /*} else if current.contains("_") {
                result = current.components(separatedBy: "_").first!
            } else if current.contains("-") {
                result = current.components(separatedBy: "-").first!
            */} else {
                result = current
            }
        }
        return result
    }
    static func serverLang() -> String {
        let langs = ["en" : "en_US", "zh-Hans" : "zh_CN", "zh-Hant" : "zh_TW", "ja" : "ja_JP", "ko" : "ko_KR"]
//        let langs = ["en" : "en_US", "zh-Hans" : "zh_CN", "zh-Hant" : "zh_TW"]
        return langs[self.userLang()] ?? "en_US"
    }
    
    static func setUserLang(_ lang: String, isPostNt: Bool = true) {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        if path == nil {
            print("setUserLang error: 未找到响应的语言包")
            return
        }
        UserDefaults.standard.set(lang, forKey: Notification.Name.userLanguage.rawValue)
        UserDefaults.standard.set([lang], forKey: Notification.Name.settingAppleLanguages.rawValue)
        UserDefaults.standard.synchronize()
        
        //第三方库语言包处理
        //MJRefresh
        Bundle.mj_resetLang()
        
        //自己的代码处理
        AYLocalizationManager.shared.bundle = Bundle.init(path: path!)!
        if isPostNt {
            NotificationCenter.default.performSelector(onMainThread: #selector(NotificationCenter.post(_:)), with: Notification.init(name: Notification.Name.settingAppleLanguages, object: nil, userInfo: ["lang" : lang]), waitUntilDone: true)
        }
    }
}

func AYLocalizedString(_ key: String, tableName: String? = "InfoPlist", bundle: Bundle = AYLocalizationManager.shared.bundle, value: String = "", comment: String) -> String {
    return bundle.localizedString(forKey: key, value: value, table: tableName)
}

extension String {
    func localized(tableName: String? = LocalizedFile.default.rawValue, bundle: Bundle = AYLocalizationManager.shared.bundle, value: String = "", comment: String? = nil) -> String {
        let result = AYLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: comment ?? self)
        #if DEBUG
        AYLocalizationManager.shared.allKeyAndValue[self] = result
        
        //key_localization
        UserDefaults.standard.set(AYLocalizationManager.shared.allKeyAndValue, forKey: key_localization)
        #endif
        return result
    }
}

////////////////////////////////////////////////////////////////////////////////
extension Notification.Name {
    static let userCurrency = Notification.Name.init("userCurrency")
    static let settingUserCurrency = Notification.Name.init("settingUserCurrency")
}

class AYCurrencyManager {
    static let shared = AYCurrencyManager.init()
    
    private init() {
    }
    
    static func userCurrency() -> String {
        var result = "USD"
        if let uc = UserDefaults.standard.string(forKey: Notification.Name.userCurrency.rawValue) {
            result = uc
        } else {
            let current = Locale.preferredLanguages.first!
            if current.hasPrefix("zh-Hans") {
                result = "CNY"
            }
        }
        return result
    }
    
    static func setUserCurrency(_ currency: String) {
        UserDefaults.standard.set(currency, forKey: Notification.Name.userCurrency.rawValue)
        UserDefaults.standard.synchronize()
        
//        MBARateInfo.modifingCurrentRate()
//        MBARateInfo.update()
        
        NotificationCenter.default.performSelector(onMainThread: #selector(NotificationCenter.post(_:)), with: Notification.init(name: Notification.Name.settingUserCurrency, object: nil, userInfo: ["currency" : currency]), waitUntilDone: true)
    }
}
