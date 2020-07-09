//
//  Extension-XArray.swift
//  DigitalClub
//
//  Created by TEZWEZ on 2019/8/30.
//  Copyright © 2019 tezwez. All rights reserved.
//

extension Array {
    ///JOSN Obj -> JSONString
    /// - Parameters:
    ///   - json: Array
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
    
    
    func judgeEqual() -> Bool {
        var flg = true
        
        guard self.count > 0 else {
            return flg
        }
        
        let firstC = self[0] as! String
        self.forEach { (elem) in
            guard elem is String else {
                flg = false
                return
            }
            
            if (elem as! String) != firstC {
                flg = false
                return
            }
        }
        
        return flg
    }
    
    //必须是数字
    func judgeInscend() -> Bool {//123456
        var flg = true
        
        guard self.count > 0 else {
            return flg
        }
        
        for (index, _) in self.enumerated() {
            if index > 0 {
                guard let fS = self[index] as? String, let fI = Int(fS) else {
                    flg = false
                    return flg
                }
                
                guard let sS = self[index - 1] as? String, let sI = Int(sS) else {
                    flg = false
                    return flg
                }

                if fI != sI + 1 {
                    flg = false
                    break
                }
            }
        }
        
        return flg
    }
    
    //必须是数字
    func judgeDescend() -> Bool {//654321
        var flg = true
        
        guard self.count > 0 else {
            return flg
        }
        
        for (index, _) in self.enumerated() {
            if index > 0 {
                guard let fS = self[index] as? String, let fI = Int(fS) else {
                    flg = false
                    return flg
                }
                
                guard let sS = self[index - 1] as? String, let sI = Int(sS) else {
                    flg = false
                    return flg
                }

                if fI != sI - 1 {
                    flg = false
                    break
                }
            }
        }
        
        return flg
    }
}
