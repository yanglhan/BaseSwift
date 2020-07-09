//
//  APPConfigure.swift
//  Growdex
//
//  Created by TEZWEZ on 2019/10/18.
//  Copyright © 2019 YUXI. All rights reserved.
//

import UIKit

class APPConfigure: NSObject {
    
    enum APP: String {
        case unknownApp = "unknownApp"
        case dev = "GDev"
        case appStore = "GAppStore"
        case enterprise = "GEnterprise"
        
        func upgradeAPPID() -> String {
            var result: String!
            switch self {
            case .appStore:
                result = "grx-iphone"
            case .dev:
                result = "grx-iphone-dev"
            case .enterprise:
                result = "grx-iphone-enterprise"
            default:
                result = "grx-iphone-unknownapp"
            }
            return result
        }

        func buglyChannel() -> String {
            var result: String!
            switch self {
            case .dev:
                result = "Dev"
            case .appStore:
                result = "App Store"
            case .enterprise:
                result = "Enterprise"
            default:
                result = "Other Release"
            }
            return result
        }
        
        func jPushAppKey() -> String {
            var result: String!
            switch self {
            case .appStore:
                result = ""
            case .enterprise:
                result = ""
            case .dev:
                result = ""
            case .unknownApp:
                result = ""
            }
            return result
        }
    }
    
    static let app: APP = {
        var result: APP!
        switch Bundle.main.bundleIdentifier {
        case "com.tezwez.ec"://appstore包
            result = APP.appStore
        case "com.tezwez.ec.dev"://开发包
            result = APP.dev
        case "com.tezwez.ec.enterprise"://企业证书包
            result = APP.enterprise
        default:
            result = APP.unknownApp
        }
        return result
    }()
}
