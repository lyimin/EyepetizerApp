//
//  EYENavigationController.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/13.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

/// 自定义导航栏控制器。。 集成子UINavigationController 实现手势返回操作
class EYENavigationController : UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) {
            interactivePopGestureRecognizer?.delegate = self
            self.navigationBar.titleTextAttributes = ["Font" : UIFont.customFont_Lobster(fontSize: UIConstant.UI_FONT_16)]
            delegate = self
        }
        navigationBar.tintColor = UIColor.blackColor()
        navigationBar.barStyle = UIBarStyle.Default
    }

    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) && animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        return super.popViewControllerAnimated(animated)
    }
    
    override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) && animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        
        return super.popToRootViewControllerAnimated(animated)
    }
    
    override func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) && animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        
        return super.popToViewController(viewController, animated: false)
    }
    
    //MARK: - UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) {
            interactivePopGestureRecognizer?.enabled = true
        }
    }
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers[0] {
                return false
            }
        }
        
        return true
    }
}
