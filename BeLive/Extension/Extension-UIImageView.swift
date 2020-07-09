//
//  Extension-UIImageView.swift
//  BmaxWallet
//
//  Created by TEZWEZ on 2019/8/22.
//  Copyright © 2019 tezwez. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
//    func setImage(with resource: URL?, placeholder: UIImage = UIImage(named: "img_default")!) {
//        self.kf.setImage(with: resource, placeholder: image)
//    }
    
    func setImage(with resource: String?, placeholder: UIImage = UIImage(named: "img_default")!) {
        let urlString = resource?.urlEncoded()
        self.kf.setImage(with: URL(string: urlString ?? ""), placeholder: placeholder)
    }
}
