//
//  Extension-Array.swift
//  EXDemo
//
//  Created by Tyler.Yin on 2018/9/8.
//  Copyright © 2018年 ayong. All rights reserved.
//

import Foundation

extension Array {
    //MARK: - 合并string元素的数组
    /// 合并string元素的数组
    ///
    /// - Parameter separator: 分隔符
    /// - Returns: 合并结果
    public func componentsJoined(by separator: String) -> String {
        return (self as NSArray).componentsJoined(by: separator)
    }
}
