//
//  BaseVC.swift
//  Growdex
//
//  Created by TEZWEZ on 2019/10/8.
//  Copyright © 2019 YUXI. All rights reserved.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

class BaseVC: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .viewBG
        self.transitioningDelegate = self
        //控制器的布局不会把透明导航算在内
        self.extendedLayoutIncludesOpaqueBars = true
        
        if #available(iOS 11.0, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        setupNavigation()
        setupSubview()
        localize()
        setupRequest()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: self.independentNavTintColor!, NSAttributedString.Key.font: UIFont.init(name: pingFangMedium, size: 18)!]
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 30
    }
    
    private lazy var customNavView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.navBarBGColor
        self.view.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(navTopHeight)
        }
        return v
    }()
    
    var navCustomColor: UIColor?/* = UIColor.white */{
        didSet {
            if navCustomColor == nil {
                customNavView.removeFromSuperview()
                return
            }
            customNavView.backgroundColor = navCustomColor
        }
    }
    
    var independentNavTintColor: UIColor? = UIColor.white {
        didSet {
            if UIDevice.current.isBeforeIOS11 {
                self.navigationController?.navigationBar.tintColor = independentNavTintColor
            } else {
                self.navigationItem.leftBarButtonItem?.tintColor = independentNavTintColor
                self.navigationItem.rightBarButtonItem?.tintColor = independentNavTintColor
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// 统一命名规则: 导航#pragma mark - Object Life Cycle相关的初始化方法
    /// ---
    /// 该方法在`viewDidLoad`中被执行, 子类重写该方法, 完成控制器中"导航相关的初始化"工作
    /// * `navigationItem`的配置， 如标题, 返回按钮, 左右两侧按钮
    /// * 导航栏颜色配置, 如前景色, 背景色
    /// * 自定义导航栏配置, 如自定义背景, 上划颜色渐变效果, 上划导航栏消失效果等
    func setupNavigation() {}
    
    /// 统一命名规则: 根视图及其直接子视图初始化方法
    /// ---
    /// 该方法在`viewDidLoad`中被执行, 子类重写该方法, 实现控制器中"根视图", 以及"根视图的直接子视图"的初始化工作. 理论上控制器只负责根视图的初始化工作, 建议由根视图类自行处理子视图的相关初始化
    /// * 通过IB方式关联的控件, 都在本方法中完成额外的样式配置工作, 如更新字体颜色, 标题内容等
    /// * 若视图不复杂时, 可以在控制器中完成对根视图的直接子视图的初始化工作, 建议使用懒加载方式加载子视图, 并在该方法的最后位置为子视图添加约束
    /// * 禁止在控制器中进行根视图的孙级子视图的初始化工作, 复杂子视图代码应抽取, 在独立的视图类中完成
    func setupSubview() {}
    
    /// 统一命名规则: 控制器中文本国际化
    /// ---
    /// 该方法在`viewDidLoad`中被执行, 子类重写该方法, 完成控制器加载后的网线请求处理
    func localize() {}
    
    /// 统一命名规则: 若控制器加载后有网络数据请求, 则在本方法中完成
    /// ---
    /// 该方法在`viewDidLoad`中被执行, 子类重写该方法, 完成控制器加载后的网线请求处理
    /// * 若控制器包含多个网络请求, 建议每个请求都写成独立方法, 在本方法中调用各个请求.
    func setupRequest() {}

    /// 兼容老版数据请求
    private lazy var vcIdentifier = NSUUID.init().uuidString
    func getSelfIdentifier() -> String {
        return vcIdentifier
    }
}

// MARK: - 横竖屏
extension BaseVC {
    //是否自动旋转,返回YES可以自动旋转
    override var shouldAutorotate: Bool {
        return false
    }
    //返回支持的方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //这个是返回优先方向
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

// MARK: - go login
//extension BaseVC {
//    func gotoLogin(_ loginSuccess: (()->Void)? = nil, _ cancelHandle: (()->Void)? = nil) {
//
//        if OPAuthID.isOpen(), (AYAuthor.shared.isLogin ?? false) {
//            let ctrl = GAuthIDVC.loadNibVC()
//            ctrl.callBack = { (state) in
//                BaseSingleton.share.appIsLogin = true
//                loginSuccess?()
//                ctrl.dismiss(animated: true, completion: nil)
//            }
//            ctrl.cancelBlock = {
//                cancelHandle?()
//                ctrl.dismiss(animated: true, completion: nil)
//            }
//            self.present(ctrl, animated: true, completion: nil)
//            return
//        }
//
//        let nav = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "loginNav") as! NavVC
//        nav.modalPresentationStyle = .fullScreen
//        nav.isTranslucent = false
//        let loginVC = nav.viewControllers[0] as! IWLoginViewController
//        loginVC.loginSuccess = loginSuccess
//        loginVC.cancelHandle = cancelHandle
//        self.show(nav, sender: nil)
//
//        return
//    }
//}

// MARK: - UIViewControllerTransitioningDelegate
extension BaseVC: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return XTransitionAnimator(transitionType: .present)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return XTransitionAnimator(transitionType: .dismiss)
    }
}
