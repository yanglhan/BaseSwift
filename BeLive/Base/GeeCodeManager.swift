//
//  GeeCodeManager.swift
//  BmaxWallet
//
//  Created by tezwez on 2019/7/12.
//  Copyright © 2019 tezwez. All rights reserved.
//

import UIKit

class GeeCodeManager: NSObject {
    
    typealias GeeCodeSuccess = ((_ geeButton: GeeCustomButton) -> Void)
    typealias StatusChange = (() -> Void)
    typealias GeeCodeFailure = (() -> Void)
    static let share: GeeCodeManager = GeeCodeManager.init()
    
    var geeButton: GeeCustomButton!
    
    var geeSuccess: GeeCodeSuccess?
    var geeFailure: GeeCodeFailure?
    var geeWillShow: StatusChange?
    var geeDidCancel: StatusChange?
    
    
    override init() {
        super.init()
        geeButton = GeeCustomButton.init(frame: CGRect.init(x: 0, y: 0, width: 260, height: 40), api1: "\(aHost)/gt/register", api2: "", lang: AYLocalizationManager.serverLang())!
        geeButton.delegate = self
    }
    
    func start(_ identify: String, success: @escaping GeeCodeSuccess) -> Bool {
        return startWith(identify: identify, success: success)
    }
    
    func startWith(identify: String, success: GeeCodeSuccess? = nil, failure: GeeCodeFailure? = nil) -> Bool {
        
        if self.isNeedReload(identify) {
            AYLoadingView.show()
            geeButton.setLang(AYLocalizationManager.serverLang())
            if (geeButton.geeParams?["sign"] != nil) {
                geeButton.clearGeeParams()
            }
            self.geeSuccess = success
            self.geeFailure = failure
            self.geeButton.identify = identify
            self.geeButton.startCaptcha()
            return false
        }
        self.geeButton.identify = identify
        self.geeSuccess = success
        self.geeFailure = failure
        return true
    }
    
    func isNeedReload(_ identify: String) -> Bool{
        if self.geeButton.geeParams.count > 0 && self.geeButton.identify != identify{
            return false
        }
        return true
    }
}

extension GeeCodeManager : CaptchaButtonDelegate {
    func captchaButtonShouldBeginTapAction(_ button: GeeCustomButton!) -> Bool {
        return true
    }
    
    func startSecondaryCaptcha(_ geeButton: GeeCustomButton!, code: String!, firstResult: [AnyHashable : Any]!, message: String!) {
        print("***startSecondaryCaptcha***")
        
        if code == "1" {
            geeSuccess?(geeButton)
        } else {
            geeFailure?()
        }
    }
    
    func geeWillAppear(_ gee: GeeCustomButton!) {
        AYLoadingView.dismiss()
    }
    
    func geeDidCancel(_ gee: GeeCustomButton!) {
        AYLoadingView.dismiss()
    }
}
