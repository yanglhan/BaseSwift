//
//  XIntervalTFView.swift
//  Growdex
//
//  Created by TEZWEZ on 2019/12/2.
//  Copyright © 2019 YUXI. All rights reserved.
//

import UIKit

class XIntervalTFView: UIView {
    
    var commitHandle: ((_ code: String) -> Void)?

    private var labs: [UILabel] = []
    private var labInterval: CGFloat = 4
    private var isSecret: Bool = false
    private var labW: CGFloat = 0
    private var labFont: UIFont = UIFont(name: "PingFangSC-Regular", size: 14)!
    private lazy var inputTF: UITextField = {
        let tf = UITextField(frame: CGRect.zero)
        tf.textColor = UIColor.clear
        tf.leftViewMode = .always
        tf.leftView = tfIntervalView
        return tf
    }()
    //tf left view
    private lazy var tfIntervalView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        return v
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func initFunc() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange(note:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    public func setupView(num: Int = 6, color: UIColor = UIColor.text1, interval: CGFloat = 4, secret: Bool = false, font: UIFont = UIFont(name: "PingFangSC-Regular", size: 14)!) {
        labInterval = interval
        isSecret = secret
        labFont = font
        
        for _ in 0...num {
            let lab = UILabel(frame: CGRect.zero)
            lab.textColor = color
            lab.font = labFont
            self.addSubview(lab)
            labs.append(lab)
            
            //添加底部线条
            let line = UIView()
            line.backgroundColor = color
            lab.addSubview(line)
            line.snp.makeConstraints { (make) in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(1)
            }
        }
        
        self.addSubview(inputTF)
        inputTF.font = labFont
        inputTF.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview()
            maker.bottom.equalTo(1)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        labW = (self.frame.size.width - labInterval * CGFloat(labs.count + 1)) / CGFloat(labs.count)
        for (index, value) in labs.enumerated() {
            value.frame = CGRect(x: labInterval * CGFloat(1 + index) + labW * CGFloat(index), y: 0, width: labW, height: self.frame.size.height)
        }
        tfIntervalView.width = labInterval + labW / 2
    }
}

extension XIntervalTFView {
    @objc fileprivate func textFieldTextDidChange(note: NSNotification) {
        guard let tf = note.object as? UITextField, tf == self.inputTF else {
            return
        }
        let str = tf.text ?? ""
        var newStr = str
        if str.length > 6 {
            newStr = String(newStr.prefix(6))
        }
        
        if str != newStr {
            self.inputTF.text = newStr
        }
        
        for (index, value) in labs.enumerated() {
            if index < newStr.length {
                value.text = isSecret ? "*" : newStr.subString(start: index, length: 1)
            } else {
                value.text = ""
            }
        }
        
        if newStr.length < labs.count {
            let textW = getLabWidth(labelStr: newStr, font: labFont, height: 1000)
            tfIntervalView.width = labs[newStr.length].left + labW / 2 - textW
        }
        
        if newStr.length == labs.count {
            if commitHandle != nil {
                commitHandle?(newStr)
            }
        }
    }
}
