//
//  YXCameraPreviewVC.swift
//  Growdex
//
//  Created by tezwez on 2019/10/16.
//  Copyright © 2019 YUXI. All rights reserved.
//

import UIKit

class YXCameraPreviewVC: BaseVC {

    let kToolHeight = safeBottom + 145
    
    lazy var customeNav: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()

    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        btn.setImage(UIImage(named: "camera_close"), for: .normal)
        return btn
    }()
    
    lazy var toolView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var tipLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: pingFangRegular, size: 14)
        label.textColor = "#555555".uiColor()
        label.textAlignment = .center
        label.text = "确保信息清晰易读".localRegister(key: "Clear_information")
        return label
    }()
    
    lazy var restartBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(restartAction), for: .touchUpInside)
        btn.titleLabel?.font = UIFont(name: pingFangBold, size: 16)
        btn.setTitleColor(UIColor.init(hexColor: "#889DBF"), for: .normal)
        btn.layer.cornerRadius = 4
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.init(hexColor: "#889DBF").cgColor
        btn.layer.borderWidth = 1
        btn.setTitle("重拍".localRegister(key: "Retake"), for: .normal)
        return btn
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        btn.titleLabel?.font = UIFont(name: pingFangBold, size: 16)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 4
        btn.layer.masksToBounds = true
        btn.backgroundColor = UIColor.init(hexColor: "#385CAD")
        btn.setTitle("确定".localRegister(key: "determine"), for: .normal)
        return btn
    }()
    
    lazy var blackView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imgV = UIImageView(frame: .zero)
        imgV.layer.masksToBounds = true
        return imgV
    }()
    
    var close: (() -> Void)?
    var restart: (() -> Void)?
    var confirm: ((_ image: UIImage?) -> Void)?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(blackView)
        blackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        blackView.addSubview(imageView)
        let imageSize = image?.size ?? .zero
        imageView.snp.makeConstraints { (make) in
            let width = screenWidth - 8*2
            let height = width/(imageSize.width/imageSize.height)
            let maxHeight = screenHeight - navTopHeight - kToolHeight
            if height < maxHeight{
                make.left.equalToSuperview().offset(8)
                make.right.equalToSuperview().offset(-8)
                make.height.equalTo(height)
                make.top.equalToSuperview().offset(navTopHeight+(maxHeight - height)/2)
            } else{
                make.height.equalTo(maxHeight)
                let imgWidth = (imageSize.width/imageSize.height)*maxHeight
                make.width.equalTo(imgWidth)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(navTopHeight-10)
            }
        }
        imageView.image = image
        
        setupCustomNav()
        setupCustomTool()
    }

    func setupCustomNav(){
        self.view.addSubview(customeNav)
        customeNav.snp.remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(navTopHeight)
        }
        
        customeNav.addSubview(closeBtn)
        
        closeBtn.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(56)
        }
    }
    
    func setupCustomTool(){
        self.view.addSubview(toolView)
        toolView.snp.remakeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(kToolHeight)
        }
        toolView.addSubview(tipLabel)
        toolView.addSubview(restartBtn)
        toolView.addSubview(confirmBtn)
        
        tipLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(20)
        }
        
        let btnWidth = (screenWidth - 13-22*2)/2
        restartBtn.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.top.equalTo(tipLabel.snp_bottom).offset(10)
            make.height.equalTo(46)
            make.width.equalTo(btnWidth)
        }
        confirmBtn.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().offset(-22)
            make.top.equalTo(tipLabel.snp_bottom).offset(10)
            make.height.equalTo(46)
            make.width.equalTo(btnWidth)
        }
    }
    
    @objc func closeAction(){
        close?()
    }
    
    @objc func restartAction(){
        self.ayDismiss(isAnimated: false)
        restart?()
    }
    
    @objc func submitAction(){
        confirm?(image)
    }
}
