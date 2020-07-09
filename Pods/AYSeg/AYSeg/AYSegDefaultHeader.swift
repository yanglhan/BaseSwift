//
//  AYSegDefaultHeader.swift
//  AYSegDemo
//
//  Created by Tyler.Yin on 2018/9/13.
//  Copyright © 2018年 ayong. All rights reserved.
//

import Foundation
import UIKit
import EX
import SnapKit

//MARK: 构造一个Bar作为header
public typealias AYSegHandle = (_ index: Int) -> Void
public class AYSegDefaultHeader: UIView {
    
    public struct UIConfigure {
        
        public var backgroundColor = UIColor.init(hexColor: "#f9f9f9")
        public var selectedViewBackgroundColor = "#32374F".uiColor()
        public var buttonTitleSelectedColor = UIColor.init(red: 36.0/255.0, green: 39.0/255.0, blue: 54.0/255.0, alpha: 1)//主题深蓝
        public var buttonTitleNormalColor: UIColor = "#666666".uiColor()
        public var bottomLineBackgroundColor = UIColor.init(red: 36.0/255.0, green: 39.0/255.0, blue: 54.0/255.0, alpha: 1)//主题深蓝
        
        public var buttonNormalFont = UIFont.systemFont(ofSize: 14)
        public var buttonSelectedFont = UIFont.systemFont(ofSize: 15)

        public static func `default`() -> UIConfigure {
            return UIConfigure()
        }

    }
    
    public var uiConfigure: UIConfigure = UIConfigure() {
        didSet {
            self.refreshUI()
        }
    }
    
    public var baseContentSize: CGSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: 44)
    override public var intrinsicContentSize: CGSize {
        return baseContentSize
    }
    
    public private(set) var buttons = [UIButton]()
    //image's name is seg_line_v
    public private(set) var lines = [UIImageView]()
    
    public private(set) var currentIndex: Int = 0
    
    public private(set) lazy var bottomLine: UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 2))
        v.backgroundColor = self.uiConfigure.bottomLineBackgroundColor
        return v
    }()
    public private(set) lazy var selectedView: UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 131, height: 32))
        v.ayCornerRadius = 16
        v.backgroundColor = uiConfigure.selectedViewBackgroundColor
        return v
    }()
    
    public var handle: AYSegHandle? = nil
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(frame: CGRect,
                            titles: [String],
                            lineImageNames: [String] ,
                            handle: AYSegHandle?,
                            buttonFont: UIFont = UIFont.systemFont(ofSize: 14),
                            buttonSelectedFont: UIFont = UIFont.systemFont(ofSize: 15),
                            buttonTitleNormalColor: UIColor = "#666666".uiColor(),
                            buttonTitleSelectedColor: UIColor = UIColor.init(red: 36.0/255.0, green: 39.0/255.0, blue: 54.0/255.0, alpha: 1)) {
        self.init(frame: frame)
        
        self.handle = handle
        
        self.backgroundColor = uiConfigure.backgroundColor
        self.uiConfigure.buttonNormalFont = buttonFont
        self.uiConfigure.buttonSelectedFont = buttonSelectedFont
        self.uiConfigure.buttonTitleNormalColor = buttonTitleNormalColor
        self.uiConfigure.buttonTitleSelectedColor = buttonTitleSelectedColor
        for (index,title) in titles.enumerated() {
            let button = UIButton.init(type: .system)
            button.tintColor = buttonTitleNormalColor
            button.setTitle(title, for: .normal)
            button.setTitleColor(buttonTitleNormalColor, for: .normal)
            button.titleLabel?.font = buttonFont
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            button.tag = index
            if index == currentIndex {
                button.setTitleColor(buttonTitleSelectedColor, for: .normal)
            }
            
            self.addSubview(button)
            
            button.snp.makeConstraints { (maker) in
                maker.top.equalTo(0)
                maker.bottom.equalTo(0)
                if index == 0 {
                    maker.left.equalTo(self)
                }else {
                    maker.left.equalTo(self.buttons.last!.snp.right)
                    maker.width.equalTo(self.buttons.first!)
                }
                if index+1 == titles.count{
                    maker.left.equalTo(self.buttons.last?.snp.right ?? 16)
                    maker.right.equalTo(self).priority(990)
                    maker.width.equalTo(self.buttons.first ?? 70).priority(991)
                }
            }
            self.buttons.append(button)
            
            if index < lineImageNames.count {
                let image = UIImage.init(named: lineImageNames[index])
                let imageView = UIImageView.init(image: image)
                imageView.contentMode = .center
                
                self.addSubview(imageView)
                
                imageView.snp.makeConstraints({ (maker) in
                    maker.top.equalTo(0)
                    maker.bottom.equalTo(0)
                    maker.width.equalTo(image?.size.width ?? 0)
                    maker.left.equalTo(button.snp.right)
                })
                
                self.lines.append(imageView)
            }
        }
        self.addSubview(bottomLine)
        let textWidth = self.buttons.first?.currentTitle?.boundingRect(with: CGSize.init(width: 100, height: 100), options: [], attributes: [NSAttributedString.Key.font : self.uiConfigure.buttonNormalFont], context: nil).size.width ?? 64
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.size.equalTo(CGSize.init(width: textWidth, height: 2))
            make.centerX.equalTo(buttons.first?.snp.centerX ?? 0)
        }
        //self.addSubview(selectedView)
        self.insertSubview(selectedView, at: 0)
        selectedView.isHidden = true
        selectedView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: textWidth+35, height: 32))
            make.centerX.equalTo(buttons.first?.snp.centerX ?? 0)
            make.centerY.equalTo(buttons.first?.snp.centerY ?? 0)
        }
        self.layoutIfNeeded()
    }
    
    private func refreshUI() {
        self.backgroundColor = uiConfigure.backgroundColor
        self.selectedView.backgroundColor = uiConfigure.selectedViewBackgroundColor
        self.bottomLine.backgroundColor = uiConfigure.bottomLineBackgroundColor
        
        for i in 0..<buttons.count {
            if i == currentIndex {
                buttons[i].setTitleColor(uiConfigure.buttonTitleSelectedColor, for: .normal)
                buttons[i].titleLabel?.font = uiConfigure.buttonSelectedFont
            }else{
                buttons[i].setTitleColor(uiConfigure.buttonTitleNormalColor, for: .normal)
                buttons[i].titleLabel?.font = uiConfigure.buttonNormalFont
            }
        }
    }
    
    public func updateUIDidEndScrolling(currentIndex: Int) {
        guard currentIndex != self.currentIndex else {
            return
        }
        print("updateUIDidEndScrollingCurrentIndex:\(currentIndex)")
        self.currentIndex = currentIndex
        for (index, button) in buttons.enumerated() {
            if index == currentIndex {
                button.setTitleColor(uiConfigure.buttonTitleSelectedColor, for: .normal)
                button.titleLabel?.font = UIFont.init(name: self.uiConfigure.buttonSelectedFont.fontName, size: uiConfigure.buttonNormalFont.pointSize+1)
            }else{
                button.setTitleColor(uiConfigure.buttonTitleNormalColor, for: .normal)
                button.titleLabel?.font = self.uiConfigure.buttonNormalFont
            }
            button.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        self.refreshSelectedUI()
        
    }
    
    public func enableBottomLine(_ enable: Bool) {
        self.bottomLine.isHidden = !enable
    }
    public func enableSelectView(_ enable: Bool) {
        self.selectedView.isHidden = !enable
    }
    
    public func updateTitles(_ titles: [String],
                             normalColor: UIColor = "#666666".uiColor(),
                             selectedColor: UIColor = UIColor.init(red: 36.0/255.0, green: 39.0/255.0, blue: 54.0/255.0, alpha: 1)) {
        print("updateTitles")
        uiConfigure.buttonTitleNormalColor = normalColor
        uiConfigure.buttonTitleSelectedColor = selectedColor
        for i in 0..<buttons.count {
            buttons[i].setTitle(titles[i], for: .normal)
            if i == currentIndex {
                buttons[i].setTitleColor(selectedColor, for: .normal)
            }else{
                buttons[i].setTitleColor(normalColor, for: .normal)
            }
        }
        
    }
    
    public func updateTitles(_ titles: [String],
                             uiConfigure: UIConfigure) {
        for i in 0..<buttons.count {
            buttons[i].setTitle(titles[i], for: .normal)
        }
        self.uiConfigure = uiConfigure
        self.refreshSelectedUI()
    }
    
    private func refreshSelectedUI() {
        UIView.animate(withDuration: 0.35) {
            let textWidth = self.buttons[self.currentIndex].currentTitle?.boundingRect(with: CGSize.init(width: 300, height: 100), options: [], attributes: [NSAttributedString.Key.font : self.uiConfigure.buttonNormalFont], context: nil).size.width ?? 64
            self.bottomLine.snp.remakeConstraints { (make) in
                make.bottom.equalTo(self)
                make.size.equalTo(CGSize.init(width: textWidth, height: 2))
                make.centerX.equalTo(self.buttons[self.currentIndex].snp.centerX)
            }
            self.selectedView.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: textWidth+35, height: 32))
                make.centerX.equalTo(self.buttons[self.currentIndex].snp.centerX)
                make.centerY.equalTo(self.buttons[self.currentIndex].snp.centerY)
            }
            self.layoutIfNeeded()
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc public func buttonClicked(_ sender: UIButton) -> Void {
        print("buttonClicked")
        self.handle?(sender.tag)
        self.updateUIDidEndScrolling(currentIndex: sender.tag)
    }
    public func setScrollStyle(BtnContentEdgeInsets: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)) {
        if self.viewWithTag(1314) is UIScrollView {
            return
        }
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        for (index, btn) in self.buttons.enumerated() {
            btn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
            scrollView.addSubview(btn)
            btn.snp.removeConstraints()
            btn.snp.makeConstraints { (maker) in
                maker.top.equalTo(0)
                maker.bottom.equalTo(0)
                maker.height.equalTo(self.snp.height)
                if index == 0 {
                    maker.left.equalToSuperview()
                }else {
                    maker.left.equalTo(self.buttons[index-1].snp.right)
                }
                if index+1 == self.buttons.count{
                    maker.right.equalTo(btn.superview!).priority(990)
                }
            }
        }
    }
}
