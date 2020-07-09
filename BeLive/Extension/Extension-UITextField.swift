//
//  Extension-UITextField.swift
//  Growdex
//
//  Created by Leon Mah Kean Loon on 24/10/2019.
//  Copyright © 2019 YUXI. All rights reserved.
//

extension UITextField {
    func leftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func rightPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    var g_placeholder: String? {
        get {
            return self.placeholder ?? ""
        }
        set {
            let placeholserAttributes = [NSAttributedString.Key.foregroundColor: UIColor.inputTextColor]
            self.attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: placeholserAttributes)
        }
    }
}
