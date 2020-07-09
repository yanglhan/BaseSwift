//
//  CellModel.swift
//  Growdex
//
//  Created by TEZWEZ on 2019/12/19.
//  Copyright © 2019 YUXI. All rights reserved.
//

struct CellModel {
    var icon = ""
    var title = ""
    var subTitle = ""
    var accIcon = ""
    var tag = ""
    
    init() {
    }
    
    init(icon: String = "", title: String = "", subTitle: String = "", accIcon: String = "", tag: String = "") {
        self.icon = icon
        self.title = title
        self.subTitle = subTitle
        self.accIcon = accIcon
        self.tag = tag
    }
}
