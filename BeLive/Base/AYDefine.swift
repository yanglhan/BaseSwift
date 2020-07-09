//
//  AYDefine.swift
//  iVCoin
//
//  Created by TEZWEZ on 2019/12/19.
//  Copyright © 2019 YUXI. All rights reserved.
//

import Foundation
import UIKit
import DeviceKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

// 自适应屏幕宽度
func fit_screenWidth(_ size: CGFloat) -> CGFloat {
    return size * screenWidth / 375.0
}
// 自适应屏幕高度
func fit_screenHeight(_ size: CGFloat) -> CGFloat {
    return size * screenHeight / 667.0
}


let isIPhoneX = Device.current == Device.iPhoneX
let isIPhoneXs = Device.current == Device.iPhoneXS
let isIPhoneXr = Device.current == Device.iPhoneXR
let isIPhoneXsMax = Device.current == Device.iPhoneXSMax
let isSimulatorX = Device.allSimulatorXSeriesDevices.contains(Device.current)
let isLiuHaiScreen = UIDevice.current.isLiuhai//(isIPhoneX||isIPhoneXs||isIPhoneXr||isIPhoneXsMax||isSimulatorX)

let navTopHeight: CGFloat = isLiuHaiScreen ? 88 : 64
let tabBarHeight: CGFloat = isLiuHaiScreen ? 83 : 49
let safeBottom: CGFloat = isLiuHaiScreen ? 34 : 0

let pingFangRegular = "PingFangSC-Regular"
let pingFangMedium = "PingFangSC-Medium"
let pingFangBold = "PingFangSC-Semibold"

let themeFontName = pingFangMedium

let FlagTag = 19900802

//资产显示、隐藏状态
let kAssetEyeIsCloseState = "KEY_ASSET_EYE_STATE"
//货币计价单位
let kCurrencyUnit = "key_currencyUnit"//保存代号coinUnitArray.1
let coinUnitArray = [("人民币".localized(), "CNY", "￥"), ("美元".localized(), "USD", "$"), ("欧元".localized(), "EUR", "€"), ("台币".localized(), "TWD", "NT$")]


// MARK: - Storage key
extension Storage.Name {
    static let loginer = Storage.Name.init(rawValue: "loginer")
}

extension Storage.Name {
    static let loginUser = Storage.Name.init(rawValue: "loginUser")
}

extension Storage.Name {
    static let lastLoginUserName = Storage.Name.init(rawValue: "lastLoginUserName")
}

extension Storage.Name {
    static let darkAppStyle = Storage.Name.init(rawValue: "darkAppStyle")
}
extension Storage.Name {
    static let cnKLineStyle = Storage.Name.init(rawValue: "cnKLineStyle")
}


extension Storage.Name {
    //行情搜索币种搜索历史[IWMarket]
    static let kCoinSearchHistory = Storage.Name.init(rawValue: "kCoinSearchHistory")
}

extension Storage.Name {
    //首页搜索币种搜索历史[IWCoin]
    static let kHomeCoinSearchHistory = Storage.Name.init(rawValue: "kHomeCoinSearchHistory")
    static let kHomeApplicationSearchHistory = Storage.Name.init(rawValue: "kHomeApplicationSearchHistory")
    static let kHomeSearchHistory = Storage.Name.init(rawValue: "kHomeSearchHistory")
    static let kHomeAppRecentUsedHistory = Storage.Name.init(rawValue: "kHomeApplicationRecentUsedHistory")
}

extension Storage.Name {
    // 指纹解锁开通状态
    static let kAuthID = Storage.Name.init(rawValue: "kAuthID")
    // md5加密数据
    static let kAuthPMD5 = Storage.Name.init(rawValue: "kAuthPMD5")
    // 指纹支付设置开启与否
    static let kAuthPayState = Storage.Name.init(rawValue: "kAuthPayState")
}

extension Storage.Name {
    // 行情搜索历史
    static let kTrendSearchCache = Storage.Name.init(rawValue: "kTrendSearchCache")
}

extension Storage.Name {
    static let kLangSelKey = Storage.Name.init(rawValue: "kLangSelKey")
}

extension Storage.Name {
    static let kHomeBannerKey = Storage.Name.init(rawValue: "kHomeBannerKey")
}

extension Storage.Name{
    static let kSettingQuoteCurrencyKey = Storage.Name.init(rawValue: "kQuoteCurrencyKey")
    static let kSettingCurrencyListKey = Storage.Name.init(rawValue: "kQuoteCurrencyListKey")
    static let kSettingLanguageKey = Storage.Name.init(rawValue: "kSetLanguageKey")
    static let kSettingLangListKey = Storage.Name.init(rawValue: "kSetLangListKey")
    static let kSettingMarketKey = Storage.Name.init(rawValue: "kSetMarketKey")
}

// MARK: - Notification key
extension Notification.Name {
    static let login = Notification.Name.init("login")
    static let logout = Notification.Name.init("logout")
    static let changeUser = Notification.Name.init(rawValue: "changeUser")
    
    static let goHome = Notification.Name.init(rawValue: "goHome")
}

extension Notification.Name {
    // 主题更换
    static let darkAppStyle = Notification.Name.init("darkAppStyle")
    // 语言更换
    static let languageChangeStyle = Notification.Name.init("languageChangeStyle")
}

extension Notification.Name {
    static let recveMessage = Notification.Name.init("recv_message")
}

