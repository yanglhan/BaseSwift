//
//  YXCameraVC.swift
//  Growdex
//
//  Created by tezwez on 2019/10/15.
//  Copyright © 2019 YUXI. All rights reserved.
//

import UIKit

class YXCameraVC: BaseVC {

    let kToolHeight = 142+safeBottom
    
    var camera: YXCameraWrapper?
    
    lazy var preview: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        return view
    }()
    
    lazy var cropView: YXCameraView = {
        let view = YXCameraView(frame: .zero)
        view.backgroundColor = .clear
        view.viewStyle.photoframeAngleW = 8
        view.viewStyle.photoframeAngleH = 8
        view.viewStyle.photoframeLineW = 2
        view.viewStyle.xScanRetangleOffset = 33
        view.viewStyle.centerUpOffset = 0
        return view
    }()
    
    lazy var flashBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(torch(_:)), for: .touchUpInside)
        btn.setImage(UIImage(named: "camera_flashlight"), for: .normal)
        return btn
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        btn.setImage(UIImage(named: "camera_close"), for: .normal)
        return btn
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("重拍", for: .normal)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var customeNav: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: pingFangBold, size: 14)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    lazy var photoButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("拍照".localRegister(key: "Take_a_photo"), for: .normal)
        btn.backgroundColor = UIColor.theme
        btn.layer.cornerRadius = 4
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont(name: pingFangBold, size: 16)
        btn.addTarget(self, action: #selector(shutterCamera), for: .touchUpInside)
        return btn
    }()
    
    lazy var tipButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "personal_auth_tip"), for: .normal)
        btn.addTarget(self, action: #selector(showAlertTip), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    lazy var tips: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: pingFangBold, size: 14)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "它是怎么工作的?".localRegister(key: "How_does_it_work_")
        label.isHidden = true
        return label
    }()
    lazy var toolView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    var confirm: ((_ image: UIImage?) -> Void)?
    var whRatio: CGFloat = 1.0
    var isNeedTipAlert = false
//    var alertStyle: GAAlertTipStyle = GAAlertTipStyle()
    var tipText: String?
    var isCrop: Bool = false
    
    var placeholder: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(preview)
        preview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if isCrop {
            self.view.addSubview(cropView)
            cropView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            cropView.viewStyle.whRatio = whRatio
            configplaceholderLabel()
            placeholderLabel.text = placeholder
        } else {
            customeNav.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            toolView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
        
        setupCustomNav()
        configTool()
        
        if isNeedTipAlert {
            tipButton.isHidden = false
            tips.isHidden = false
            placeholderLabel.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        perform(#selector(start), with: nil, afterDelay: 0.3)
    }
    
    func configTool(){
        self.view.addSubview(toolView)
        toolView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(kToolHeight)
        }
        
        toolView.addSubview(photoButton)
        toolView.addSubview(tipButton)
        toolView.addSubview(tips)
        tips.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(22)
            make.centerX.equalToSuperview()
        }
        tipButton.snp.remakeConstraints { (make) in
            make.right.equalTo(tips.snp_left)
            make.centerY.equalTo(tips.snp_centerY)
            make.height.equalTo(46)
            make.width.equalTo(40)
        }
        photoButton.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.right.equalToSuperview().offset(-22)
            make.top.equalTo(tips.snp_bottom).offset(16)
            make.height.equalTo(46)
        }
    }
    
    func configplaceholderLabel() {
        
        let rect = self.imageCropRect()
        
        self.view.addSubview(placeholderLabel)
        placeholderLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalTo(self.view.snp_centerY).offset(-rect.size.height/2-10)
        }
    }
    
    func setupCustomNav(){
        self.view.addSubview(customeNav)
        customeNav.snp.remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(navTopHeight)
        }
        
        customeNav.addSubview(closeBtn)
        customeNav.addSubview(flashBtn)
        
        closeBtn.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(56)
        }
        
        flashBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(56)
        }
    }

    // MARK: - Action
    @objc func start(){
        if camera == nil {
            camera = YXCameraWrapper(videoPreView: preview)
            camera?.takeImageFinish = { [weak self] (_ image: UIImage?) in
                
                var rect = CGRect(x: 0, y: navTopHeight, width: screenWidth, height: self!.preview.frame.size.height - self!.kToolHeight - navTopHeight)
                if self?.isCrop ?? false {
                    rect = self?.imageCropRect() ?? .zero
                }
                let newImage = image?.imageScale(toSize: CGSize(width: screenWidth, height: screenHeight))
                
                let showImage = newImage?.imageInRect(rect: rect)
                
                let ctrl = YXCameraPreviewVC()
                ctrl.image = showImage
                self?.ayPresent(ctrl)
                ctrl.close = {
                    self?.closeAction()
                }
                ctrl.restart = {
                    self?.cancelAction()
                }
                ctrl.confirm = {(image) in
                    self?.confirm?(image)
                    self?.closeAction()
                }
            }
        }
        camera?.start()
    }
    @objc func torch(_ btn: UIButton){
        camera?.torch()
    }
    
    @objc func closeAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func shutterCamera(){
        camera?.shutterCamera()
    }
    
    @objc func cancelAction(){
        camera?.restart()
    }

    @objc func showAlertTip(){
//        let ctrl = GAHoldTipVC()
//        ctrl.style = self.alertStyle
//        self.ayPresent(ctrl)
    }
}

extension YXCameraVC{
    private func imageCropRect() -> CGRect{
        let XRetangleLeft = self.cropView.viewStyle.xScanRetangleOffset
        var sizeRetangle = CGSize(width: screenWidth - XRetangleLeft * 2.0, height: self.cropView.frame.size.width - XRetangleLeft * 2.0)
        if self.cropView.viewStyle.whRatio != 1.0 {
            let w = sizeRetangle.width
            var h = w / self.cropView.viewStyle.whRatio
            h = CGFloat(Int(h))
            sizeRetangle = CGSize(width: w, height: h)
        }
        let YMinRetangle = self.cropView.frame.size.height / 2.0 - sizeRetangle.height / 2.0 - self.cropView.viewStyle.centerUpOffset
        let rect = CGRect(x: XRetangleLeft, y: YMinRetangle, width: sizeRetangle.width, height: sizeRetangle.height)
        return rect
    }
}
