//
//  String+Eye.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/14.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import Foundation

extension String {
    /// 获取字符串长度
    var length : Int {
        return characters.count
    }
}

extension Int {
    static func durationToTimer(duration : Int) -> String {
        return "\(String(format: "%02d", duration/60))' \(String(format: "%02d", duration%60))\""
    }
}