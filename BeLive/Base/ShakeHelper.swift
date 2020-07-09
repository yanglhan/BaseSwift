//
//  ShakeHelper.swift
//  GLibraPlanet
//
//  Created by YUXI on 2019/9/7.
//  Copyright © 2019 YUXI. All rights reserved.
//

import Foundation
import AudioToolbox

class ShakeHelper {
    
    static let shared = ShakeHelper.init()
    
    @available(iOS 10.0, *)
    private lazy var impactFeedBack = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
    
    private init() {
        if #available(iOS 10.0, *) {
            impactFeedBack.prepare()
        } else {
        }
    }
    
    func prepare() {
        if #available(iOS 10.0, *) {
            impactFeedBack.prepare()
        } else {
        }
    }
    
    func impactOccurred() {
        if #available(iOS 10.0, *) {
            impactFeedBack.impactOccurred()
        } else {
            /*
             //短震  3D Touch中的peek震动反馈
             AudioServicesPlaySystemSound(1519);
             //短震  3D Touch中的pop震动反馈
             AudioServicesPlaySystemSound(1520);
             //连续三次短震动
             AudioServicesPlaySystemSound(1521);
             */
            AudioServicesPlaySystemSound(1519);        }
    }
    
}

extension ShakeHelper {
    static func msgShake() {
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, nil, nil, { (sid: SystemSoundID, p: UnsafeMutableRawPointer?) in

        }, nil)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    static func msgSound() {
        AudioServicesPlaySystemSound(1007);
    }
}
