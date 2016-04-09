//
//  EYEVideoDetailPopTransition.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/25.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class EYEVideoDetailPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private var fromVC : EYEVideoDetailController!
    private var toVC : EYEBaseViewController!
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! EYEVideoDetailController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! EYEBaseViewController
        let container = transitionContext.containerView()
        self.fromVC = fromVC
        self.toVC = toVC
        
        fromVC.detailView.backBtn.alpha = 0
        // 背景图片
        let snapshotView = fromVC.detailView.albumImageView.snapshotViewAfterScreenUpdates(false)
        snapshotView.frame = fromVC.detailView.albumImageView.frame
        fromVC.detailView.albumImageView.hidden = true
        fromVC.detailView.blurImageView.hidden = true
        fromVC.detailView.blurView.hidden = true
        fromVC.detailView.bottomToolView.hidden = true
        
        // 覆盖层
        let cover = UIView(frame: snapshotView.frame)
        cover.backgroundColor = UIColor.blackColor()
        cover.alpha = 0
        
        // 模糊图片
        let blurImageView = fromVC.detailView.blurImageView.snapshotViewAfterScreenUpdates(false)
        blurImageView.frame = fromVC.detailView.blurImageView.frame
        
        let blurEffect : UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurImageView.frame
        // 设置tovc属性
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.selectCell.backgroundImageView.hidden = true
        toVC.selectCell.titleLabel.alpha = 0
        toVC.selectCell.subTitleLabel.alpha = 0
        
//        container!.insertSubview(toVC.view, belowSubview: fromVC.view)
        container?.addSubview(toVC.view)
        container!.addSubview(snapshotView)
        container?.addSubview(cover)
        container?.addSubview(blurImageView)
        container?.addSubview(blurView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            // 图片
            let snapshotFrame = container!.convertRect(toVC.selectCell.backgroundImageView.frame, fromView: toVC.selectCell)
            snapshotView.frame = snapshotFrame
            // 覆盖层
            cover.frame = snapshotFrame
            cover.alpha = 0.3
            
            // 模糊图片
            blurImageView.frame = CGRect(x: 0, y: CGRectGetMaxY(snapshotFrame), width: CGRectGetWidth(snapshotFrame), height: 0)
            blurView.frame = CGRect(x: 0, y: CGRectGetMaxY(snapshotFrame), width: CGRectGetWidth(snapshotFrame), height: 0)
            
        }) { [unowned self](finish: Bool) -> Void in
            toVC.selectCell.backgroundImageView.hidden = false
            fromVC.detailView.backBtn.alpha = 1
            
            snapshotView.removeFromSuperview()
            cover.removeFromSuperview()
            blurImageView.removeFromSuperview()
            blurView.removeFromSuperview()
            
            fromVC.detailView.albumImageView.hidden = false
            fromVC.detailView.blurImageView.hidden = false
            fromVC.detailView.blurView.hidden = false
            fromVC.detailView.bottomToolView.hidden = false
            // 文字动画
            self.titleAnimation()
            // tabbar动画
            if !fromVC.panIsCancel {
                self.tabbarAnimation()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
    
    /**
     执行tabbar动画
     */
    private func tabbarAnimation() {
        // tabbar
        let tabbarSnapshotView = toVC.tabBarController?.tabBar
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear, animations: {
            tabbarSnapshotView?.y = UIConstant.SCREEN_HEIGHT - UIConstant.UI_TAB_HEIGHT
        }) { (_) in
        
        }
    }
    
    
    private func titleAnimation() {
        UIView.animateWithDuration(0.3) {
            self.toVC.selectCell.titleLabel.alpha = 1
            self.toVC.selectCell.subTitleLabel.alpha = 1
        }
    }
}
