//
//  TabbarVC.swift
//  Growdex
//
//  Created by TEZWEZ on 2019/10/8.
//  Copyright © 2019 YUXI. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {
    
    private lazy var msgCountLabel: UILabel = {
        let d: CGFloat = 10
        let msgCountLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: d, height: d))
        msgCountLabel.backgroundColor = UIColor.theme
        msgCountLabel.ayCornerRadius = d/2
        msgCountLabel.tag = 900802
        msgCountLabel.text = "!"
        msgCountLabel.adjustsFontSizeToFitWidth = true
        msgCountLabel.font = UIFont.boldSystemFont(ofSize: 9)
        msgCountLabel.minimumScaleFactor = 0.1
        msgCountLabel.textAlignment = .center
        msgCountLabel.textColor = UIColor.white
        msgCountLabel.isHidden = true
        return msgCountLabel
    }()
    
    deinit {
        tabBar.removeObserver(self, forKeyPath: "frame")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        tabBar.addObserver(self, forKeyPath: "frame", options: [.old, .new], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goHomeNotiAction(_:)), name: Notification.Name.goHome, object: nil)
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        for item in tabBar.items ?? [] {
////            item.image = item.image?.rendering(tintColor: UIColor.tabNormalTextColor)
////            item.selectedImage = item.selectedImage?.rendering(tintColor: UIColor.tabTintColor)?.withRenderingMode(.alwaysOriginal)
////            item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
//            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.tabNormalTextColor], for: .normal)
//            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.tabTintColor], for: .selected)
//            item.titlePositionAdjustment.vertical = -2
//        }
//    }
    
    //kvo 观察tabbar frame变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let bar = object as? UITabBar, keyPath == "frame" {
            if let oldF = change?[.oldKey] as? CGRect, let newF = change?[.newKey] as? CGRect {
                if oldF.size != newF.size {
                    if oldF.height > newF.height {
                        bar.frame = oldF
                    } else {
                        bar.frame = newF
                    }
                }
            }
        }
    }
    
    //震动
    private func vibrate() {
        if #available(iOS 10.0, *) {
            let impactLight = UIImpactFeedbackGenerator(style: .light)
            impactLight .impactOccurred()
        } else {
            // Fallback on earlier versions
        }
    }
    
    //返回首页通知
    @objc func goHomeNotiAction(_ noti: Notification) {
        self.selectedIndex = 0
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.selectedViewController?.prefersStatusBarHidden ?? false
    }
}

// MARK: - UITabBarControllerDelegate
extension TabbarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        self.vibrate()
        if viewController == tabBarController.viewControllers?[3] {
            // 判断 app 是不是登陆的逻辑
//            if !BaseSingleton.share.appIsLogin, OPAuthID.isOpen(), (AYAuthor.shared.isLogin ?? false) {
//                let ctrl = GAuthIDVC.loadNibVC()
//                ctrl.callBack = { (state) in
//                    BaseSingleton.share.appIsLogin = true
//                    ctrl.dismiss(animated: true, completion: nil)
//                }
//                ctrl.cancelBlock = {
//                    ctrl.dismiss(animated: true, completion: nil)
//                }
//                self.present(ctrl, animated: true, completion: nil)
//                return false
//            }
//
//
//            if !BaseSingleton.share.appIsLogin || !(AYAuthor.shared.isLogin ?? false) {
//                let nav = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "loginNav") as! NavVC
//                nav.modalPresentationStyle = .fullScreen
//                nav.isTranslucent = true
//                self.show(nav, sender: nil)
//                return false
//            }
        }
        return true
    }
}

// MARK: - 横竖屏
extension TabbarVC {
    override var shouldAutorotate: Bool {
        //是否自动旋转,返回YES可以自动旋转
        return self.selectedViewController?.shouldAutorotate ?? false
    }
    //返回支持的方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations ?? .allButUpsideDown
    }
    //这个是返回优先方向
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}
