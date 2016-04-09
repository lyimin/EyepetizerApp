//
//  EYEPlayerView.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/29.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class EYEPlayerView: UIView {
    // 播放进度
    @IBOutlet weak var sliderView: UISlider!
    // 开始时间
    @IBOutlet weak var startLabel: UILabel!
    // 结束时间
    @IBOutlet weak var endLabel: UILabel!
    // 开始按钮
    @IBOutlet weak var startButton: UIButton!
    // 缓存进度
    @IBOutlet weak var progressView: UIProgressView!
    // 菊花
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    // 返回按钮
    @IBOutlet weak var backBtn: UIButton!
    // 快进，后退按钮
    @IBOutlet weak var horizontalLabel: UILabel!
    // 顶部view
    @IBOutlet weak var topView: UIView!
    // 顶部阴影
    @IBOutlet weak var topCoverView: UIView!
    // 影片名
    @IBOutlet weak var titleLabel: UILabel!
    // 底部view
    @IBOutlet weak var bottomView: UIView!
    // 底部阴影
    @IBOutlet weak var bottomCoverView: UIView!
    
    // 是否显示覆盖层
    private var isShowCoverView : Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置进度条属性
        self.sliderView.setThumbImage(UIImage(named: "slider"), forState: .Normal)
        self.insertSubview(self.progressView, belowSubview: self.sliderView)
        self.sliderView.minimumTrackTintColor = UIColor.whiteColor()
        self.sliderView.maximumTrackTintColor = UIColor(colorLiteralRed: 0.3, green: 0.3, blue: 0.3, alpha: 0.6)
        
        // 设置缓存进度条属性
        self.progressView.progressTintColor    = UIColor.whiteColor()
        self.progressView.trackTintColor       = UIColor.clearColor()
        
        // 设置快进快退label
        self.horizontalLabel.backgroundColor = UIColor(patternImage: UIImage(named: "Management_Mask")!)
        self.indicatorView.stopAnimating()
        self.horizontalLabel.hidden = true
        
        // 点击屏幕
        let tap = UITapGestureRecognizer(target: self, action: #selector(EYEPlayerView.tapAction))
        self.addGestureRecognizer(tap)
    }
    
    /**
     加载view
     */
    class func playerView() -> EYEPlayerView {
        return NSBundle.mainBundle().loadNibNamed("EYEPlayerView", owner: nil, options: nil).first as! EYEPlayerView
    }
    
    /**
     隐藏底部view和顶部view动画
     */
    @objc private func hiddenAnimation() {
        isShowCoverView = false
        
        UIView.animateWithDuration(0.2, animations: {
            self.topView.transform = CGAffineTransformMakeTranslation(0, -50)
            self.topCoverView.transform = CGAffineTransformMakeTranslation(0, -50)
            
            self.bottomView.transform = CGAffineTransformMakeTranslation(0, 50)
            self.bottomCoverView.transform = CGAffineTransformMakeTranslation(0, 50)
        }) { (_) in
            
            self.topView.hidden = true
            self.topCoverView.hidden = true
            
            self.bottomCoverView.hidden = true
            self.bottomView.hidden = true
        }
    }
    
    /**
     显示底部view和顶部view动画
     */
    private func showAnimation() {
        
        isShowCoverView = true
        
        self.topView.hidden = false
        self.topCoverView.hidden = false
        
        self.bottomCoverView.hidden = false
        self.bottomView.hidden = false
        
        UIView.animateWithDuration(0.2, animations: {
            self.topView.transform = CGAffineTransformIdentity
            self.topCoverView.transform = CGAffineTransformIdentity
            
            self.bottomCoverView.transform = CGAffineTransformIdentity
            self.bottomView.transform = CGAffineTransformIdentity
        }) { [unowned self](_) in
            self.afterHidden()
        }
    }
    
    
    /**
     点击屏幕
     */
    @objc private func tapAction() {
        if isShowCoverView {
            self.hiddenAnimation()
        } else {
            self.showAnimation()
        }
    }
    
    /**
     延迟隐藏底部view和顶部view
     */
    private func afterHidden() {
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(EYEPlayerView.hiddenAnimation), object: nil)
        self.performSelector(#selector(EYEPlayerView.hiddenAnimation), withObject: nil, afterDelay: 5.0)
    }


}
