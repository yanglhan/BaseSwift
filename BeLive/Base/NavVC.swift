//
//  NavVC.swift
//  Growdex
//
//  Created by TEZWEZ on 2019/10/8.
//  Copyright © 2019 YUXI. All rights reserved.
//

import UIKit

class NavVC: UINavigationController {

    var barTintColor = UIColor.navBarTintColor
    var navBarBGColor = UIColor.navBarBGColor
    var isTranslucent = false
    var navBarShadowVisible = false
    var navBarTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    var navTintColor = UIColor.white
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        } else {
            // Fallback on earlier versions
        }
        self.navigationBar.barTintColor = barTintColor
        self.navigationBar.setBackground(navBarBGColor)
        self.navigationBar.isTranslucent = isTranslucent
        self.navigationBar.setShadowVisible(navBarShadowVisible)
        self.navigationBar.titleTextAttributes = navBarTitleTextAttributes
        self.navigationBar.tintColor = navTintColor
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.tabNormalTextColor], for: .normal)
//        self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.tabTintColor], for: .selected)
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.addNavLeftItem(self.navigationBar.tintColor)
        }
        super.pushViewController(viewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc override func navigationBack() {
        popViewController(animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        return self.viewControllers.last?.prefersStatusBarHidden ?? false
    }

}

// MARK: - 横纵屏
extension NavVC {
    //是否自动旋转,返回YES可以自动旋转
    override var shouldAutorotate: Bool {
        return self.viewControllers.last?.shouldAutorotate ?? true
    }
    //返回支持的方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.viewControllers.last?.supportedInterfaceOrientations ?? .allButUpsideDown
    }
    
    //这个是返回优先方向
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.viewControllers.last?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}

extension UIViewController {
    @objc func addNavLeftItem(_ color: UIColor = UIColor.white) {
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_back"), style: .plain, target: self, action: #selector(navigationBack))
        leftBarButtonItem.tintColor = color
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func navigationBack() {
        if self.navigationController?.viewControllers.count == 1, self.navigationController?.viewControllers.last == self {
            self.navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
}
