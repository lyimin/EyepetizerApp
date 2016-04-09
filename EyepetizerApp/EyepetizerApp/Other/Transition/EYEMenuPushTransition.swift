//
//  EYEMenuPushTransition.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/4/7.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit
//
//class EYEMenuPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
//    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
//        return 5
//    }
//    
//    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        let container = transitionContext.containerView()
//        //1.获取动画的源控制器和目标控制器
//        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! EYEChoiceController
//        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! EYEMenuViewController
//        
//        // 获取fromvc view
////        let fromVCSnapshotView = fromVC.view.snapshotViewAfterScreenUpdates(false)
//        // 获取菜单按钮
//        let fromVCMenuBtn = fromVC.navigationItem.leftBarButtonItem?.customView
//        fromVCMenuBtn!.frame = container!.convertRect(fromVC.menuBtn.frame, fromView: fromVC.navigationController?.navigationBar)
//        
//        toVC.leftBarButtonItem.customView?.hidden = true
//        
//        //4.都添加到 container 中。注意顺序不能错了
//        container!.addSubview(toVC.view)
//        container!.addSubview(fromVCMenuBtn!)
//        
//        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 
//            fromVCMenuBtn!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
//            
//            }) { (_) in
//                toVC.leftBarButtonItem.customView?.hidden = false
//                fromVCMenuBtn!.removeFromSuperview()
//                
//                //一定要记得动画完成后执行此方法，让系统管理 navigation
//                transitionContext.completeTransition(true)
//        }
//    }
//}
