//
//  AYInputAccessoryView.swift
//  iVCoin
//
//  Created by TEZWEZ on 2019/12/19.
//  Copyright © 2019 YUXI. All rights reserved.
//

import UIKit

@objc protocol AYInputAccessoryViewDelegate {
    @objc optional func backToLastInput(_ sender: UIResponder?)
    @objc optional func gotoNextInput(_ sender: UIResponder?)
}

class AYInputAccessoryView: UIToolbar {
    
    weak var inputAccessoryViewDelegate: AYInputAccessoryViewDelegate?
    weak var resigner: ResignProtocol?
    weak var lastInput: UIResponder? {
        didSet {
            backItem.tintColor = (lastInput != nil) ? UIColor.text1 : UIColor.text1.withAlphaComponent(0.35)
        }
    }
    weak var currentInput: UIResponder? {
        didSet {
            nextItem.tintColor = (nextInput != nil) ? UIColor.text1 : UIColor.text1.withAlphaComponent(0.35)
        }
    }
    weak var nextInput: UIResponder?
    
    private weak var backItem: UIBarButtonItem!
    private weak var nextItem: UIBarButtonItem!

    init(_ resigner: ResignProtocol? = nil, lastInput: UIResponder? = nil, currentInput: UIResponder? = nil, nextInput: UIResponder? = nil) {
        super.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: UIScreen.main.bounds.width, height: 38)))
        self.resigner = resigner
        self.lastInput = lastInput
        self.currentInput = currentInput
        self.nextInput = nextInput
        self.setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.barTintColor = "#caced4".uiColor()
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "input_back")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backAction(_:)))
        let spaceItem0 = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem0.width = 16
        let nextItem = UIBarButtonItem.init(image: UIImage.init(named: "input_next")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(nextAction(_:)))
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem.init(title: "Done".localized(), style: .done, target: self, action: #selector(resignAllFirstResponder))
        doneItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], for: .normal)
        
        backItem.tintColor = (lastInput != nil) ? UIColor.text1 : UIColor.text1.withAlphaComponent(0.35)
        nextItem.tintColor = (nextInput != nil) ? UIColor.text1 : UIColor.text1.withAlphaComponent(0.35)
        
        doneItem.tintColor = UIColor.text1
        
        let placeholderLabel = UILabel.init(frame: CGRect.init(x: 100, y: 0, width: UIScreen.main.bounds.width-200, height: self.bounds.height))
        placeholderLabel.font = UIFont.systemFont(ofSize: 12)
        placeholderLabel.textColor = UIColor.gray.withAlphaComponent(0.5)
        placeholderLabel.center = CGPoint.init(x: self.bounds.width/2, y: self.bounds.height/2)
        placeholderLabel.textAlignment = .center
        self.addSubview(placeholderLabel)
        
        if let tf = currentInput as? UITextField {
            var title = tf.attributedPlaceholder?.string
            if (title?.count ?? 0) == 0 {
                title = tf.placeholder
            }
            if (title?.count ?? 0) > 0 {
                placeholderLabel.text = title
            }
        }else if let searchBar = currentInput as? UISearchBar {
            if let tf = searchBar.value(forKey: "searchField") as? UITextField {
                var title = tf.attributedPlaceholder?.string
                if (title?.count ?? 0) == 0 {
                    title = tf.placeholder
                }
                if (title?.count ?? 0) > 0 {
                    placeholderLabel.text = title
                }
            }
        } else if (currentInput as? UITextView) != nil {
            placeholderLabel.text = ""
        }
        
        self.items = [backItem, spaceItem0, nextItem, spaceItem, doneItem]
    }
    
    @objc private func backAction(_ sender: UIResponder?) {
        guard inputAccessoryViewDelegate == nil else{
            inputAccessoryViewDelegate?.backToLastInput?(sender)
            return
        }
        guard lastInput != nil, lastInput!.canBecomeFirstResponder else {
            return
        }
        lastInput?.becomeFirstResponder()
        if (nextInput?.canResignFirstResponder ?? false) {
            nextInput?.resignFirstResponder()
        }
    }
    
    @objc private func nextAction(_ sender: UIResponder?) {
        guard inputAccessoryViewDelegate == nil else{
            inputAccessoryViewDelegate?.gotoNextInput?(sender)
            return
        }
        guard nextInput != nil, nextInput!.canBecomeFirstResponder else {
            return
        }
        nextInput?.becomeFirstResponder()
        if (lastInput?.canResignFirstResponder ?? false) {
            lastInput?.resignFirstResponder()
        }
    }
    
    @objc private func resignAllFirstResponder() {
        resigner?.resignAllFirstResponder()
    }
}
