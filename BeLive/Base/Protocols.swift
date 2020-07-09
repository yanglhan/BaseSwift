//
//  Protocols.swift
//  FashionMix
//
//  Created by YUXI on 2017/5/22.
//  Copyright © 2017年 YUXI. All rights reserved.
//

import SwiftyJSON

protocol Copyable: class {
    func copy() -> Copyable
}

protocol Updateable {
    associatedtype Model
    func update(model: Model)
    func updated(model: Model) -> Model
}

typealias Properties = Dictionary<String, Any>
protocol Modelable {
    
    /// 转化成Dictionary<String, Any>格式，用于save操作
    ///
    /// - Returns: 需要保存Model的属性列表
    func properties() -> Properties
    
    /// 读取数据（读出来就是Properties），然后生成新的实例
    ///
    /// - Parameter properties: 属性
    /// - Returns: 返回实例
    static func model(properties: Properties) -> Modelable
    
}

protocol JSONParse {
    init(aJSON: JSON)
    init(fromDictionary dictionary: [String: Any])
    func toDictionary() -> [String: Any]
}


@objc protocol ResignProtocol: class {
    func resignAllFirstResponder()
}

extension UIViewController: ResignProtocol {
    func resignAllFirstResponder() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}

@objc protocol LocalizationProtocol: class {
    @objc optional func reLocalize()
}

@objc protocol ResetAppStyle: class {
    @objc optional func resetAppStyle()
}
