//
//  Protocol.swift
//  EXDemo
//
//  Created by zhiyong yin on 2019/6/27.
//  Copyright © 2019 ayong. All rights reserved.
//


//MARK: - 自定义View定义的协议方法
public protocol UI {
    
    /// 用于调整UI的接口
    func adjustUI()
    
    /// UI添加事件
    func addEvents()
    
    /// 用来添加子视图的接口
    func addSubviews()
    
    /// 用来给子视图添加约束的接口
    func addConstraints()
    
    /// 设置数据源
    func configure<T>(model: T)
}

public extension UI {
    /// 用于调整UI的接口
    func adjustUI(){}
    
    /// UI添加事件
    func addEvents(){}
    
    /// 用来添加子视图的接口
    func addSubviews(){}
    
    /// 用来给子视图添加约束的接口
    func addConstraints(){}
    
    /// 设置数据源
    func configure<T>(model: T) {}
}
