//
//  EYEMenuBtn.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/4/1.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit
/**
 菜单按钮类型
 
 - EYEMenuBtnTypeNone: 默认是只有一张图片
 - EYEMenuBtnTypeDate: 有一个label来显示日期的按钮
 */
public enum EYEMenuBtnType {
    case None
    case Date
}
class EYEMenuBtn: UIButton {
   
    // 类型
    private var type : EYEMenuBtnType = .None
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = UIFont.customFont_Lobster()
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.setImage(UIImage(named: "ic_action_menu"), forState: .Normal)
    }
    
    convenience init(frame: CGRect, type: EYEMenuBtnType) {
        self.init(frame: frame)
        
        self.type = type
        
        if type == .Date {
            self.setTitle("Today", forState: .Normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        if type == .Date{
            return CGRect(x: self.height-UIConstant.UI_MARGIN_10, y: 0, width: self.width-self.height+UIConstant.UI_MARGIN_10, height: self.height)
        }
        return CGRectZero
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: self.height, height: self.height)
    }
}
