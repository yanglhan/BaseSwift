//
//  Extension-XDictionary.swift
//  DigitalClub
//
//  Created by TEZWEZ on 2019/8/30.
//  Copyright © 2019 tezwez. All rights reserved.
//

extension Dictionary {
    ///JOSN Obj -> JSONString
    /// - Parameters:
    ///   - json: Dictionary
    /// - Returns: JSONString
    func JSONStringFromJSONObject() -> String? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return nil
        }
        let data = try? JSONSerialization.data(withJSONObject: self, options: []) as NSData?
        let JSONString = NSString(data:data! as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}
