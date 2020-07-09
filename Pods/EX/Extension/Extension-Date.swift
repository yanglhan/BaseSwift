//
//  Extension-Date.swift
//  AYSeg
//
//  Created by zhiyong yin on 2019/4/26.
//

import Foundation

extension Date {
    
    //MARK: - 获取明天的日期
    /// 获取明天的日期
    ///
    /// - Returns: 当前日期时间往未来推移24小时Date
    public func tomorrow() -> Date {
        return Date.init(timeIntervalSince1970: self.timeIntervalSince1970+3600*24)
    }
    //MARK: - 获取昨天的日期
    /// 获取昨天的日期
    ///
    /// - Returns: 当前日期时间往历史推移24小时Date
    public func yesterday() -> Date {
        return Date.init(timeIntervalSince1970: self.timeIntervalSince1970-3600*24)
    }
}
