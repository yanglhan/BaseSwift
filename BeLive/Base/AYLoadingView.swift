//
//  AYLoadingView.swift
//  iVCoin
//
//  Created by TEZWEZ on 2019/12/19.
//  Copyright © 2019 YUXI. All rights reserved.
//

import UIKit

class AYLoadingView: UIView {
    
    private static let shared = AYLoadingView.init(frame: CGRect.zero)
    private var requestCount = 0

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.darkAppStyle, object: nil)
    }
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        UIApplication.shared.delegate?.window??.addSubview(self)
        self.addSubview(loadingBG)
//        self.addSubview(loadingText)
        self.addSubview(loadingImage)
        
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        loadingBG.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 120, height: 85))
        }
//        loadingText.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.size.equalTo(CGSize.init(width: 90, height: 90))
//        }
        loadingImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
//            make.size.equalTo(CGSize.init(width: 90, height: 90))
            make.size.equalTo(CGSize.init(width: 70, height: 70))
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedResetAppStyleNotification(_:)), name: NSNotification.Name.darkAppStyle, object: nil)
    }
    
    init(frame: CGRect, inView: UIView!) {
        super.init(frame: frame)
        
        inView!.addSubview(self)
        self.addSubview(loadingBG)
        //        self.addSubview(loadingText)
        self.addSubview(loadingImage)
        
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        loadingBG.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 120, height: 85))
        }
        //        loadingText.snp.makeConstraints { (make) in
        //            make.center.equalToSuperview()
        //            make.size.equalTo(CGSize.init(width: 90, height: 90))
        //        }
        loadingImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            //            make.size.equalTo(CGSize.init(width: 90, height: 90))
            make.size.equalTo(CGSize.init(width: 70, height: 70))
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedResetAppStyleNotification(_:)), name: NSNotification.Name.darkAppStyle, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //NotificationCenter.default.addObserver(self, selector: #selector(receivedResetAppStyleNotification(_:)), name: NSNotification.Name.darkAppStyle, object: nil)
    }
    
    private lazy var loadingBG: UIImageView = {
        let loadingBG = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 90, height: 90))
        loadingBG.contentMode = .center
//        if darkStyle {
//            loadingBG.image = UIImage.init(named: "loading_bg")
//        }else{
            loadingBG.image = nil
//        }
        
        return loadingBG
    }()
    
    private lazy var loadingText: UIImageView = {
        let loadingText = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 90, height: 90))
        loadingText.contentMode = .center
        loadingText.image = UIImage.init(named: "loading_text")
        
        return loadingText
    }()
    
    private lazy var loadingImage: UIImageView = {
        let loadingImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 90, height: 90))
        loadingImage.contentMode = .center
//        loadingImage.tintColor = UIColor.text
//        if darkStyle {
//            loadingImage.image = UIImage.init(named: "loading_circle")?.withRenderingMode(.alwaysOriginal)
//        }else{
            loadingImage.image = UIImage.init(named: "loading_circle")?.withRenderingMode(.alwaysTemplate)
//        }
        
        return loadingImage
    }()
    

    func startAnimation() {
        self.isHidden = false
        let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.duration = 1.3
        rotationAnimation.isCumulative = true
        rotationAnimation.toValue = Float.pi*2
        rotationAnimation.repeatCount = Float(Int.max)
        loadingImage.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
    }
    func stopAnimation() {
        loadingImage.layer.removeAllAnimations()
        self.isHidden = true
    }
    
    static func show() {
        if Thread.current.isMainThread {
            AYLoadingView.shared.requestCount += 1
            if AYLoadingView.shared.requestCount <= 1 {
                AYLoadingView.shared.requestCount = 1
                AYLoadingView.shared.startAnimation()
            }
        }else{
            DispatchQueue.main.async {
                AYLoadingView.shared.requestCount += 1
                if AYLoadingView.shared.requestCount <= 1 {
                    AYLoadingView.shared.requestCount = 1
                    AYLoadingView.shared.startAnimation()
                }
            }
        }
        
    }
    
    static func showInView(_ view: UIView!) {
        if Thread.current.isMainThread {
            self.dismiss(view)
            let loading = AYLoadingView.init(frame: CGRect.zero, inView: view)
            loading.startAnimation()
        }else{
            DispatchQueue.main.async {
                self.dismiss(view)
                let loading = AYLoadingView.init(frame: CGRect.zero, inView: view)
                loading.startAnimation()
            }
        }
    }
    
    static func dismiss(_ superView: UIView?) {
        guard superView != nil else {
            return
        }
        superView?.subviews.forEach { (subview: UIView) in
            if subview.isKind(of: AYLoadingView.self) {
                (subview as! AYLoadingView).stopAnimation()
                subview.removeFromSuperview()
            }
        }
    }
    
    static func dismiss() {
        if Thread.current.isMainThread {
            AYLoadingView.shared.requestCount -= 1
            if AYLoadingView.shared.requestCount <= 0 {
                AYLoadingView.shared.requestCount = 0
                AYLoadingView.shared.stopAnimation()
            }
        }else{
            DispatchQueue.main.async {
                AYLoadingView.shared.requestCount -= 1
                if AYLoadingView.shared.requestCount <= 0 {
                    AYLoadingView.shared.requestCount = 0
                    AYLoadingView.shared.stopAnimation()
                }
            }
        }
    }
}


extension AYLoadingView: ResetAppStyle {
    @objc func receivedResetAppStyleNotification(_ notification: Notification) {
        self.resetAppStyle()
    }
    func resetAppStyle() {
//        if darkStyle {
//            loadingBG.image = UIImage.init(named: "loading_bg")
//            loadingImage.image = UIImage.init(named: "loading_circle")?.withRenderingMode(.alwaysOriginal)
//        }else{
            loadingImage.image = UIImage.init(named: "loading_circle")?.withRenderingMode(.alwaysTemplate)
            loadingBG.image = nil
//        }
    }
}
