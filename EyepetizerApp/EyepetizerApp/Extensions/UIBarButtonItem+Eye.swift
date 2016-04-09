//
//  UIBarButtonItem+Eye.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/13.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func barButtonItemWithImg(image : UIImage!, selectorImg : UIImage?, target : AnyObject!, action : Selector!) -> UIBarButtonItem {
        
        let view = UIView()
        view.frame = CGRectMake(0, 0, 80, 40)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .ScaleAspectFit
        imageView.frame = CGRectMake(-10, 0, 40, 40)
        view.addSubview(imageView)
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        
        return UIBarButtonItem(customView: view)
    }
}