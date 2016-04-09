//
//  EYEVideoDetailTransition.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/23.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class EYEVideoDetailPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private var toVC : EYEVideoDetailController!
    private var fromVC : EYEBaseViewController!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        //1.获取动画的源控制器和目标控制器
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! EYEBaseViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! EYEVideoDetailController
        
        self.fromVC = fromVC
        self.toVC = toVC
        
        //2.创建一个 Cell 中 imageView 的截图，并把 imageView 隐藏，造成使用户以为移动的就是 imageView 的假象
        let backgroundSnapshotView = fromVC.view.snapshotViewAfterScreenUpdates(false)
        // 图片
        let snapshotView = fromVC.selectCell.backgroundImageView.snapshotViewAfterScreenUpdates(false)
        snapshotView.frame = container!.convertRect(fromVC.selectCell.backgroundImageView.frame, fromView: fromVC.selectCell)
        fromVC.selectCell.backgroundImageView.hidden = true
        // 覆盖层
        let coverView = fromVC.selectCell.coverButton.snapshotViewAfterScreenUpdates(false)
        coverView.frame = container!.convertRect(fromVC.selectCell.coverButton.frame, fromView: fromVC.selectCell)
        
        // 模糊背景
        let blurImageView = UIImageView(image: fromVC.selectCell.backgroundImageView.image)
        blurImageView.frame = CGRectMake(0, CGRectGetMaxY(snapshotView.frame), snapshotView.width, 0)
        
        let blurEffect : UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurImageView.frame
        
        // tabbar
        let tabbarSnapshotView = fromVC.tabBarController?.tabBar
        //3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.detailView.albumImageView.alpha = 0
        toVC.detailView.blurImageView.alpha = 0
        toVC.detailView.backBtn.alpha = 0
        toVC.detailView.playImageView.alpha = 0
        toVC.detailView.classifyLabel.alpha = 0
        toVC.detailView.describeLabel.alpha = 0
        toVC.detailView.bottomToolView.alpha = 0
        //4.都添加到 container 中。注意顺序不能错了
        container!.addSubview(toVC.view)
        container?.addSubview(backgroundSnapshotView)
        container!.addSubview(snapshotView)
        container?.addSubview(coverView)
        container?.addSubview(blurImageView)
        container?.addSubview(blurView)
        //5.执行动画
        toVC.detailView.albumImageView.layoutIfNeeded()

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            // 图片
            snapshotView.frame = toVC.detailView.albumImageView.frame
            // 覆盖层
            coverView.frame = toVC.detailView.albumImageView.frame
            coverView.alpha = 0
            // 模糊背景
            blurImageView.frame = toVC.detailView.blurImageView.frame
            blurView.frame = toVC.detailView.blurImageView.frame
            
        }) { [unowned self](finish: Bool) -> Void in
            toVC.detailView.albumImageView.image = fromVC.selectCell.backgroundImageView.image
            toVC.detailView.albumImageView.alpha = 1
            toVC.detailView.blurImageView.alpha = 1
            // 移除假象图片
            backgroundSnapshotView.removeFromSuperview()
            coverView.removeFromSuperview()
            snapshotView.removeFromSuperview()
            blurImageView.removeFromSuperview()
            blurView.removeFromSuperview()
            // 其它动画
            self.playBtnAnimation()
            self.titleAnimation()
            self.subTitleAnimation()
            // 还原图片
            fromVC.selectCell.backgroundImageView.hidden = false
            fromVC.selectCell.coverButton.alpha = 0.3
            fromVC.selectCell.titleLabel.alpha = 1
            fromVC.selectCell.subTitleLabel.alpha = 1
            
            //一定要记得动画完成后执行此方法，让系统管理 navigation
            transitionContext.completeTransition(true)
        }

        // tabbar 延迟0.2秒动画
        UIView.animateWithDuration(0.1, delay: 0.2, options: .CurveLinear, animations: {
            tabbarSnapshotView?.y = UIConstant.SCREEN_HEIGHT
            fromVC.navigationController?.navigationBar.y = -UIConstant.UI_NAV_HEIGHT
            }) { (_) -> Void in
                fromVC.navigationController?.navigationBarHidden = true
        }

    }
    
    /**
     播放,返回按钮动画
     */
    private func playBtnAnimation() {
        let playView = toVC.detailView.playImageView
        UIView.transitionWithView(playView, duration: 0.5, options: .CurveEaseOut, animations: {
            self.toVC.detailView.playImageView.alpha = 1
            self.toVC.detailView.backBtn.alpha = 1
            }, completion: nil)
    }
    /**
     *  启动文字动画
     */
    
    private func titleAnimation () {
        let titleView = toVC.detailView.videoTitleLabel
        titleView.startAnimation()
    }
    
    /**
     描述文字动画
     */
    private func subTitleAnimation() {
        UIView.animateWithDuration(0.3, delay: 0.5, options: .CurveEaseInOut, animations: {
            self.toVC.detailView.classifyLabel.alpha = 1
            self.toVC.detailView.describeLabel.alpha = 1
            self.toVC.detailView.bottomToolView.alpha = 1
            }, completion: nil)
    }
}
