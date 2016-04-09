//
//  EYEDiscoverModel.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/16.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

struct EYEDiscoverModel {
    var id : Int!
 /// 分类名
    var name : String!
 /// 化名
    var alias : String!
 /// 背景图
    var bgPicture : String!
 /// 背景色
    var bgColor : String!
    
    init (dict : NSDictionary) {
        self.id = dict["id"] as? Int ?? 0
        self.name = dict["name"] as? String ?? ""
        self.alias = dict["alias"] as? String ?? ""
        self.bgPicture = dict["bgPicture"] as? String ?? ""
        self.bgColor = dict["bgColor"] as? String ?? ""
    }
}
