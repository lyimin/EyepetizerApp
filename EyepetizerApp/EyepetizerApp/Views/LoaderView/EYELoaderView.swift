//
//  EYELoaderView.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/17.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class EYELoaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(eyeBackgroundLoaderView)
        self.addSubview(eyeCenterLoaderView)        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoadingAnimation() {
        self.hidden = false
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = M_PI * 2
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = HUGE
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        self.eyeCenterLoaderView.layer.addAnimation(animation, forKey: animation.keyPath)
    }
    
    func stopLoadingAnimation() {
//        self.hidden = true
        self.eyeCenterLoaderView.layer.removeAllAnimations()
    }
    
    /// 外面眼圈
    private lazy var eyeBackgroundLoaderView : UIImageView = {
        let eyeBackgroundLoaderView = UIImageView(image: UIImage(named: "ic_eye_black_outer"))
        eyeBackgroundLoaderView.frame = CGRect(x: 0, y: 0, width: self.height,height: self.height)
        eyeBackgroundLoaderView.center = self.center
        eyeBackgroundLoaderView.contentMode = .ScaleAspectFit
        eyeBackgroundLoaderView.layer.allowsEdgeAntialiasing = true
        return eyeBackgroundLoaderView;
    }()
    
    /// 中间眼球
    private lazy var eyeCenterLoaderView : UIImageView = {
        let eyeCenterLoaderView = UIImageView(image: UIImage(named: "ic_eye_black_inner"))
        eyeCenterLoaderView.frame = CGRect(x: 0, y: 0, width: self.height - UIConstant.UI_MARGIN_5, height: self.height - UIConstant.UI_MARGIN_5)
        eyeCenterLoaderView.center = self.center
        eyeCenterLoaderView.contentMode = .ScaleAspectFit
        eyeCenterLoaderView.layer.allowsEdgeAntialiasing = true
        return eyeCenterLoaderView;
    }()
}
