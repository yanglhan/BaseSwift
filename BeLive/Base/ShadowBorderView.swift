//
//  ShadowBorderView.swift
//  DigitalClub
//
//  Created by TEZWEZ on 2019/9/2.
//  Copyright © 2019 tezwez. All rights reserved.
//

import UIKit

class ShadowBorderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 6
        layer.shadowOpacity = 0.16
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor(rgb: 0xAFAFAF).cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 6
        layer.shadowOpacity = 0.16
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor(rgb: 0xAFAFAF).cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}
