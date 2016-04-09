//
//  EYETabbarTransition.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/19.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

/// tabbar切换动画
class EYETabbarTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let duration : NSTimeInterval = 0.4
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView : UIView = transitionContext.containerView()!
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view
        
        containerView.addSubview(toView!)
        toView?.alpha = 0
        fromView?.alpha = 1
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            toView?.alpha = 1
            fromView?.alpha = 0
            
            }) { (_) -> Void in
                
                transitionContext.completeTransition(true)
        }
        
    }
}
