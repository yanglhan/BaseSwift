//
//  OPAuthID.swift
//  BmaxWallet
//
//  Created by Apple on 2019/6/15.
//  Copyright © 2019 tezwez. All rights reserved.
//

import UIKit
import LocalAuthentication


enum OPAuthPolicy: Int {
    case deviceOwnerAuthentication
    case deviceOwnerAuthenticationWithBiometrics
}

/**
 *  TouchID/FaceID 状态
 */
enum  OPAuthIDState : Int{
    
    /**
     *  当前设备不支持TouchID/FaceID
     */
    case NotSupport = 0
    /**
     *  TouchID/FaceID 验证成功
     */
    case Success = 1
    
    /**
     *  TouchID/FaceID 验证失败
     */
    case Fail = 2
    /**
     *  TouchID/FaceID 被用户手动取消
     */
    case UserCancel = 3
    /**
     *  用户不使用TouchID/FaceID 选择手动输入登录密码
     */
    case InputPassword = 4
    /**
     *  TouchID/FaceID 被系统取消 (如遇到来电 锁屏 按了Home键等)
     */
    case SystemCancel = 5
    /**
     *  TouchID/FaceID 无法启动 因为用户没有设置密码
     */
    case PasswordNotSet = 6
    /**
     *  TouchID/FaceID 无法启动 因为用户没有设置TouchID/FaceID
     */
    case TouchIDNotSet = 7
    /**
     *  TouchID/FaceID 无效
     */
    case TouchIDNotAvailable = 8
    /**
     *  TouchID/FaceID 被锁定(连续多次验证TouchID/FaceID失败 系统需要用户手动输入密码)
     */
    case TouchIDLockout = 9
    /**
     *  当前软件被挂起并取消了授权 (如App进入了后台等)
     */
    case AppCancel = 10
    /**
     *  当前软件被挂起并取消了授权 (LAContext对象无效)
     */
    case InvalidContext = 11
    /**
     *  系统版本不支持TouchID/FaceID (必须高于iOS 8.0才能使用)
     */
    case VersionNotSupport = 12
};

class OPAuthID: NSObject {
    
    
    static func savePayMD5(_ md5: String!){
        Storage.save(key: Storage.Name.kAuthPMD5, value: md5 as Any)
    }
    static func md5() -> String?{
        let md5p = Storage.load(key: Storage.Name.kAuthPMD5)
        return md5p as? String
    }
    
    static func savePayState(_ state: Bool!) {
        Storage.save(key: Storage.Name.kAuthPayState, value: state as Any)
    }
    static func isOpenPay() -> Bool! {
        let state: Bool? = Storage.load(key: Storage.Name.kAuthPayState) as? Bool
        return state ?? false
    }
    
    // 指纹解锁是否打开
    static func save(state: Bool!){
        Storage.save(key: Storage.Name.kAuthID, value: state as Any)
    }
    
    static func isOpen() -> Bool!{
        let state: Bool? = Storage.load(key: Storage.Name.kAuthID) as? Bool
        return state ?? false
    }
    
    // deviceOwnerAuthenticationWithBiometrics: 用TouchID/FaceID验证
    // deviceOwnerAuthentication: 用TouchID/FaceID或密码验证, 默认是错误两次或锁定后,
    static func showAuthID(policy: OPAuthPolicy? = OPAuthPolicy.deviceOwnerAuthenticationWithBiometrics, describe: String?, localizedFallbackTitle: String?, result: @escaping (OPAuthIDState, NSError?) -> Void){
        var desc = describe
        if desc == nil {
            if isLiuHaiScreen {
                desc = "验证已有面容".localized()
            } else {
                desc = "通过Home键验证已有指纹".localized()
            }
        }
        
        if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
//            dispatch_async(dispatch_get_main_queue()  ^{
//                NSLog(@"系统版本不支持TouchID/FaceID (必须高于iOS 8.0才能使用)");
//                block(case VersionNotSupport  nil);
//            });
            
            DispatchQueue.main.async {
                result(OPAuthIDState.NotSupport, nil)
            }
            return
        }
        
        let context = LAContext.init()
        // 认证失败提示信息，为 @"" 则不提示
        context.localizedFallbackTitle = localizedFallbackTitle
        if #available(iOS 10.0, *) {
//            context.localizedCancelTitle = "取消".localRegister(key: "cancel")
        } else {
            
        }
        // 指纹解锁校验间隔  10s 内无需重复验证
//        context.touchIDAuthenticationAllowableReuseDuration = 10
        var error: NSError?
        
        var _policy = LAPolicy.deviceOwnerAuthentication
        if policy == OPAuthPolicy.deviceOwnerAuthenticationWithBiometrics {
            _policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        }
        
        if context.canEvaluatePolicy(_policy, error: &error) {
            context .evaluatePolicy(_policy, localizedReason: desc!) { (success, err) in
                DispatchQueue.main.async {
                    if success {
                        result(OPAuthIDState.Success, nil)
                    } else {
                        let errorCode = err!
                        switch errorCode{
                        case LAError.authenticationFailed:
                            result(OPAuthIDState.Fail, nil)
                            break
                        case LAError.userFallback:
                            // UserCancel
                            result(OPAuthIDState.InputPassword, nil)
                            break
                        case LAError.passcodeNotSet:
                            // UserCancel
                            result(OPAuthIDState.PasswordNotSet, nil)
                            break
                        case LAError.touchIDLockout:
                            // UserCancel
                            result(OPAuthIDState.TouchIDLockout, nil)
                            break
                        case LAError.userCancel:
                            // UserCancel
                            result(OPAuthIDState.UserCancel, nil)
                            break
                        default:
                            result(OPAuthIDState.Fail, nil)
                            break
                        }
                    }
                }
            }
        }
        
        if error != nil {
            DispatchQueue.main.async {
                if #available(iOS 11.0, *) {
                    if error?.code == LAError.touchIDLockout.rawValue {
                        
                        result(OPAuthIDState.TouchIDLockout, nil)
                    } else if error?.code == LAError.touchIDNotEnrolled.rawValue{
                        result(OPAuthIDState.TouchIDNotSet, nil)
                    } else if error?.code == LAError.biometryNotEnrolled.rawValue{
                        result(OPAuthIDState.TouchIDNotSet, nil)
                    } else {
                        result(OPAuthIDState.NotSupport, nil)
                    }
                } else {
                    // Fallback on earlier versions
                    if error?.code == LAError.touchIDLockout.rawValue {
                        result(OPAuthIDState.TouchIDLockout, nil)
                    } else if error?.code == LAError.touchIDNotEnrolled.rawValue{
                        result(OPAuthIDState.TouchIDNotSet, nil)
                    } else {
                        result(OPAuthIDState.NotSupport, nil)
                    }
                }
            }
        }
        
    }
}
