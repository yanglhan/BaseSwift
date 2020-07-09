//
//  AYNetworkCode.swift
//  iVCoin
//
//  Created by YUXI on 2017/12/18.
//  Copyright © 2017年 YUXI. All rights reserved.
//

import Foundation

struct AYNetworkCode {
    static let success = 0
    static let invalidToken = 41001
    static let noToken = 41003
    static let expiredToken = 40001

    var rawValue = 0
    func debugMessage() -> String {
        var msg: String
        switch rawValue {
        case AYNetworkCode.success:
            msg = "成功".localized()
        case AYNetworkCode.invalidToken:
            msg = "无效Token".localized()
        case AYNetworkCode.noToken:
            msg = "无Token".localized()
        case AYNetworkCode.expiredToken:
            msg = "无效凭证，access_token无效或不是最新的。".localized()
        case -1:
            msg = "系统繁忙".localized()
        case -2:
            msg = "参数验证不通过".localized()
        case -3:
            msg = "文件上传失败".localized()
        case 40002:
            msg = "用户已存在（手机号码已注册）".localized()
        case 40003:
            msg = "验证码错误".localized()
        case 40004:
            msg = "谷歌验证码错误，请重新输入".localized()
        case 40005:
            msg = "原密码错误".localized()
        case 40006:
            msg = "身份证校验不通过".localized()
        case 40007:
            msg = "图片验证码输入错误".localized()
        case 40008:
            msg = "用户名已存在".localized()
        case 40009:
            msg = "您已设置过用户名了".localized()
        case 40010:
            msg = "邮箱已存在".localized()
        case 40011:
            msg = "行为验证未通过".localized()
        case 40012:
            msg = "无效的access_key_id".localized()
        case 50059:
            msg = "当前用户未设置手机号码".localized()
        case 50060:
            msg = "当前用户未设置邮箱".localized()
        case 50061:
            msg = "验证码或者新的手机号不能为空".localized()
        case 50062:
            msg = "验证码或者新的邮箱不能为空".localized()
        case 50063:
            msg = "旧的手机号的验证码不正确或者失效".localized()
        case 50064:
            msg = "新的手机号的验证码不正确或者失效".localized()
        case 50065:
            msg = "旧的邮箱的验证码不正确或者失效".localized()
        case 50066:
            msg = "新的邮箱的验证码不正确或者失效".localized()
        default:
            msg = "服务器繁忙，请稍后再试！".localized()
        }
        return msg
    }
    func message() -> String {
        return self.debugMessage()
    }
}
