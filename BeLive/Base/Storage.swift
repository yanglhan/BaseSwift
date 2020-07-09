//
//  Storage.swift
//  FashionMix
//
//  Created by YUXI on 2017/6/1.
//  Copyright © 2017年 YUXI. All rights reserved.
//

import Foundation
import CryptoSwift


final class Storage {
    struct Name {
        private(set)var rawValue: String
        
        init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - Storage
extension Storage {
    static func save(key: Storage.Name, value: Modelable) -> Void {
//        UserDefaults.standard.set(value.properties(), forKey: key.rawValue)
        //加密存储
        guard let data = try? JSONSerialization.data(withJSONObject: value.properties(), options: []) else {
            return
        }
        guard let jsonString = String.init(data: data, encoding: .utf8) else {
            return
        }
        guard let encryptString = jsonString.aes(.encrypt) else {
            return
        }
        
        UserDefaults.standard.set(encryptString, forKey: key.rawValue)
        
        UserDefaults.standard.synchronize()
    }
    static func load(key: Storage.Name, className: Modelable.Type) -> Modelable? {
//        if let properties = UserDefaults.standard.value(forKey: key.rawValue) as? Properties {
//            return className.model(properties: properties)
//        }
//        return nil
        
        //读取后解密
        guard let encryptString = UserDefaults.standard.string(forKey: key.rawValue) else {
            return nil
        }
        guard let jsonString = encryptString.aes(.decrypt) else {
            return nil
        }
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return nil
        }
        
        guard let properties = obj as? [String : Any] else {
            return nil
        }
        
        return className.model(properties: properties)
    }
    static func remove(key: Storage.Name) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
}

// MARK: - Any
extension Storage {
    static func save(key: Storage.Name, value: Any) -> Void {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    static func load(key: Storage.Name) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
}

// MARK: - String
extension Storage {
    static func string(key: Storage.Name) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    static func stringValue(key: Storage.Name) -> String {
        return UserDefaults.standard.string(forKey: key.rawValue) ?? ""
    }
}

// MARK: - Bool
extension Storage {
    static func bool(key: Storage.Name) -> Bool? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? Bool
    }
    static func boolValue(key: Storage.Name) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
}

// MARK: - Number
extension Storage {
    //Int
    static func int(key: Storage.Name) -> Int? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? Int
    }
    static func intValue(key: Storage.Name) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    //Double
    static func double(key: Storage.Name) -> Double? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? Double
    }
    static func doubleValue(key: Storage.Name) -> Double {
        return UserDefaults.standard.double(forKey: key.rawValue)
    }
    //Float
    static func float(key: Storage.Name) -> Float? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? Float
    }
    static func floatValue(key: Storage.Name) -> Float {
        return UserDefaults.standard.float(forKey: key.rawValue)
    }
}



fileprivate let aesKey = "com.be.gexchange.data.aes.a.b.c."
extension String {
    enum CryptMod {
        case encrypt
        case decrypt
    }
    func aes(_ mod: CryptMod) -> String? {
        let key = aesKey
        let aes = try! AES(key: key.bytes, blockMode: ECB(), padding: .pkcs5)
        switch mod {
        case .encrypt:
            return ((try? self.encryptToBase64(cipher: aes)) ?? nil)
            //print("加密结果(base64)：\(encrypted)")
        case .decrypt:
            return (try? self.decryptBase64ToString(cipher: aes))
            //print("解密结果：\(decrypted)")
        }
    }
}
