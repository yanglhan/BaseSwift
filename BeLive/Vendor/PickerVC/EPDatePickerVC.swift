//
//  EPDatePickerVC.swift
//  EPPlay
//
//  Created by TEZWEZ on 2019/8/13.
//  Copyright © 2019 YuXiTech. All rights reserved.
//

import UIKit

class EPDatePickerVC: BaseVC {
    private(set) lazy var datePicker: EPDatePickerView = {
        let picker = EPDatePickerView(frame: .zero, type: datePickerType, initialDate: selectedDate, minDate: minimumDate, maxDate: maximumDate)
        self.pickerView.addSubview(picker)
        return picker
    }()
    
    private(set) lazy var maskBtn: UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitleColor(.black, for: .normal)
        bt.alpha = 0.6
        bt.addTarget(self, action: #selector(maskBtnAction(_:)), for: .touchUpInside)
        self.view.addSubview(bt)
        return bt
    }()
    
    private(set) lazy var pickerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        self.view.addSubview(view)
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("取消".localRegister(key: "cancel"), for: .normal)
        cancelBtn.setTitleColor(.theme, for: .normal)
        cancelBtn.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 15)
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_:)), for: .touchUpInside)
        
        let submitBtn = UIButton(type: .custom)
        submitBtn.setTitle("完成".localRegister(key: "carry_out"), for: .normal)
        submitBtn.setTitleColor(.theme, for: .normal)
        submitBtn.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 15)
        submitBtn.addTarget(self, action: #selector(submitBtnAction(_:)), for: .touchUpInside)

        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = self.pickerTitle
        titleLabel.textColor = .text3
        titleLabel.font = UIFont(name: "PingFangSC-Semibold", size: 15)

        let stackView = UIStackView(arrangedSubviews: [cancelBtn, titleLabel, submitBtn])
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        self.pickerView.addSubview(stackView)
        
        return stackView
    }()
    
    // MARK: Object Life Cycle
    var pickerTitle: String
    var datePickerMode: UIDatePicker.Mode?
    var datePickerType: EPDatePickerView.DatePickerType
    var minimumDate: Date?
    var maximumDate: Date?
    var tColor: UIColor = UIColor(rgb: 0xEAEAED)
    var tFont: UIFont = UIFont(name: pingFangMedium, size: 18)!
    var didSelectedBlock: ((_ date: Date)->Void)?
    
    private var selectedDate: Date
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(title: String) instead")
    }
    
    init(title: String, dateType: EPDatePickerView.DatePickerType = .default, initialDate: Date = Date(), minDate: Date? = nil, maxDate: Date? = nil, textColor: UIColor = UIColor(rgb: 0xEAEAED), textFont: UIFont = UIFont(name: pingFangMedium, size: 18)!) {
        self.pickerTitle = title
        datePickerType = dateType
        selectedDate = initialDate
        minimumDate = minDate
        maximumDate = maxDate
        tColor = textColor
        tFont = textFont
        
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.transitioningDelegate = self
        self.modalPresentationStyle = .overCurrentContext
    }
    
    override func setupSubview() {
        maskBtn.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        pickerView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(self.view.snp.bottom)
        }
        
        stackView.snp.makeConstraints({ (maker) in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview().offset(16)
            maker.right.equalToSuperview().offset(-16)
            maker.height.equalTo(49)
        })
        
        datePicker.snp.makeConstraints { (maker) in
            maker.top.equalTo(stackView.snp.bottom)
            maker.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - event action
extension EPDatePickerVC {
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        print(sender.date)
        selectedDate = sender.date
        self.didSelectedBlock?(selectedDate)
    }
    
    // MARK: Event Response
    @objc func maskBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func submitBtnAction(_ sender: UIButton) {
        self.didSelectedBlock?(datePicker.myDate() ?? Date())
        self.dismiss(animated: true, completion: nil)
    }
}

//// MARK: UIViewControllerTransitioningDelegate
extension EPDatePickerVC {
    override public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return EPTransitionAnimator(transitionType: .present, maskView: maskBtn, contentView: pickerView)
    }

    override public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return EPTransitionAnimator(transitionType: .dismiss, maskView: maskBtn, contentView: pickerView)
    }
}


