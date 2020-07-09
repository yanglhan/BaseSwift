//
//  Extension-XViewController.swift
//  DigitalClub
//
//  Created by TEZWEZ on 2019/8/30.
//  Copyright © 2019 tezwez. All rights reserved.
//

extension UIViewController {
    ///跳转到APP系统设置权限界面
    func gotoSystemPrivacySetting() {
        let appSetting = URL(string: UIApplication.openSettingsURLString)
        if appSetting != nil {
            if #available(iOS 10, *) {
                UIApplication.shared.open(appSetting!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appSetting!)
            }
        }
    }
}

// 自定义控制器加载
extension UIViewController{
    
    enum AYPresentSide {
        case top
        case left
        case bottom
        case right
    }
    
    func ayPresent(_ controller: UIViewController, animated: Bool = true, beginForm: AYPresentSide = .bottom, isShowInPop: Bool = false){
        
        let parent = self.navigationController ?? self
        
        if animated {
            parent.view.addSubview(controller.view)
            parent.addChild(controller)
            var startFrame: CGRect = CGRect.zero
            let endFrame: CGRect = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
            switch beginForm{
            case .top:
                startFrame = CGRect.init(x: 0, y: -screenHeight, width: screenWidth, height: screenHeight)
                break
            case .left:
                startFrame = CGRect.init(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
                break
            case .right:
                startFrame = CGRect.init(x: -screenWidth, y: 0, width: screenWidth, height: screenHeight)
                break
            default:
                startFrame = CGRect.init(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
                break
            }
            
            controller.view.frame = startFrame
            controller.view.backgroundColor = UIColor.clear
            UIView.animate(withDuration: 0.35, animations: {
                controller.view.frame = endFrame
                if isShowInPop == false{
                    controller.view.backgroundColor = UIColor.init(hex: 0, alpha: 0.3)
                }
            }) { (success) in
                
            }
        } else {
            let endFrame: CGRect = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
            controller.view.frame = endFrame
            parent.view.addSubview(controller.view)
            parent.addChild(controller)
        }
    }
    
    func ayDismiss(isAnimated: Bool, to: AYPresentSide = .bottom){
        if isAnimated {
            var endFrame: CGRect = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
            switch to{
            case .top:
                endFrame = CGRect.init(x: 0, y: -screenHeight, width: screenWidth, height: screenHeight)
                break
            case .left:
                endFrame = CGRect.init(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
                break
            case .right:
                endFrame = CGRect.init(x: -screenWidth, y: 0, width: screenWidth, height: screenHeight)
                break
            default:
                endFrame = CGRect.init(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
                break
            }
            
            UIView.animate(withDuration: 0.35, animations: {
                self.view.frame = endFrame
            }) { (success) in
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
            
        } else {
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}


extension UIViewController {
    func present(_ vc: UIViewController, pushAnimation: Bool = false, defaultAnimation: Bool = true, completion: (() -> Void)? = nil) {
        guard pushAnimation else {
            self.present(vc, animated: defaultAnimation, completion: completion)
            return
        }
        let animation = CATransition()
        animation.duration = 0.35
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromRight
        animation.setValue("\(NSStringFromClass(self.classForCoder))--pushAnimation", forKey: "value")
        
        self.view.window?.layer.add(animation, forKey: nil)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: completion)
    }
    func dismiss(popAnimation: Bool = false, defaultAnimation: Bool = true, completion: (() -> Void)? = nil) {
        guard popAnimation else {
            self.dismiss(animated: defaultAnimation, completion: completion)
            return
        }
        let animation = CATransition()
        animation.duration = 0.35
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromLeft
        animation.setValue("\(NSStringFromClass(self.classForCoder))--popAnimation", forKey: "value")
        
        self.view.window?.layer.add(animation, forKey: nil)
        self.dismiss(animated: false, completion: completion)
    }
}
