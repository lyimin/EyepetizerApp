//
//  UIFont+Eye.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/11.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

extension UIFont {
    /**
     自定义字体 -- 粗体
     */
    class func customFont_FZLTZCHJW(fontSize size : CGFloat = UIConstant.UI_FONT_12) -> UIFont {
        return UIFont(name: "FZLanTingHeiS-DB1-GB", size: size)!
    }
    
    /**
     自定义字体 - 细体
     */
    class func customFont_FZLTXIHJW(fontSize size : CGFloat = UIConstant.UI_FONT_12) -> UIFont {
        return UIFont(name: "FZLanTingHeiS-L-GB", size: size)!
    }
    
    /**
     自定义字体 - 邪邪的那种
     */
    class func customFont_Lobster (fontSize size : CGFloat = UIConstant.UI_FONT_12) -> UIFont {
        return UIFont(name: "Lobster 1.4", size: size)!
    }
    
//    class func customFont(fontPath path : String!, fontSize size : CGFloat = EYEConstant.UIConstant.UI_FONT_12) -> UIFont {
//        guard let _ = path else {
//            return UIFont.systemFontOfSize(size)
//        }
//        // 获取字体路径
//        let url = NSURL(fileURLWithPath: path)
//        let fontDataProvider : CGDataProviderRef = CGDataProviderCreateWithURL(url)!
//        let fontRef : CGFontRef = CGFontCreateWithDataProvider(fontDataProvider)!
//        CTFontManagerRegisterGraphicsFont(fontRef, nil);
//        let fontName : NSString = CGFontCopyPostScriptName(fontRef) as! NSString
//        let font = UIFont(name: fontName as String, size: size)
//        return font!
//    }
}