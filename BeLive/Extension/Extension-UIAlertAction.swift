//
//  Extension-UIAlertAction.swift
//  Growdex
//
//  Created by YUXI on 2019/10/15.
//  Copyright © 2019 YUXI. All rights reserved.
//


extension UIAlertAction {
    func setBtnTitleColor(_ titleTextColor: UIColor) {
        self.setValue(titleTextColor, forKey: "titleTextColor")
    }
}
