//
//  EYEMenuHeaderView.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/4/2.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class EYEMenuHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        // 添加控件
        self.addSubview(backgroundIconView)
        backgroundIconView.addSubview(eyeIconView)
        self.addSubview(loginLabel)
        self.addSubview(lineView)
        self.addSubview(collectionLabel)
        self.addSubview(commentLabel)
    
        // 适配
        backgroundIconView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(UIConstant.UI_MARGIN_10)
        }
        backgroundIconView.layer.cornerRadius = 50
        
        eyeIconView.snp_makeConstraints { (make) in
            make.edges.equalTo(backgroundIconView)
        }
        
        loginLabel.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(backgroundIconView.snp_bottom).offset(UIConstant.UI_MARGIN_10)
            make.height.equalTo(20)
        }
        
        lineView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.loginLabel.snp_bottom).offset(UIConstant.UI_MARGIN_20)
//            make.top.equalTo(self.snp_bottom).offset(-UIConstant.UI_MARGIN_10)
            make.width.equalTo(1)
            make.height.equalTo(20)
        }
        
        collectionLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(UIConstant.UI_MARGIN_20)
            make.right.equalTo(self.lineView)
            make.top.equalTo(self.loginLabel.snp_bottom).offset(UIConstant.UI_MARGIN_20)
            make.height.equalTo(20)
        }
        
        commentLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.lineView)
            make.right.equalTo(self).offset(-UIConstant.UI_MARGIN_20)
            make.top.equalTo(collectionLabel.snp_top)
            make.height.equalTo(collectionLabel.snp_height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 头像
    private lazy var backgroundIconView : UIView = {
        var backgroundIconView : UIView = UIView()
        backgroundIconView.backgroundColor = UIColor.lightGrayColor()
        backgroundIconView.layer.borderColor = UIColor.whiteColor().CGColor
        backgroundIconView.layer.borderWidth = 2
            
        return backgroundIconView
    }()
    
    // 眼镜
    private lazy var eyeIconView : UIImageView = {
        var eyeIconView: UIImageView = UIImageView(image: UIImage(named: "ic_action_focus_white"))
        eyeIconView.contentMode = .ScaleAspectFit
        return eyeIconView
    }()
    
    // 登录标签
    private lazy var loginLabel : UILabel = {
        var loginLabel : UILabel = UILabel()
        loginLabel.text = "点击登录后可评论"
        loginLabel.textAlignment = .Center
        loginLabel.textColor = UIColor.blackColor()
        loginLabel.font = UIFont.customFont_FZLTXIHJW(fontSize: UIConstant.UI_FONT_14)
        return loginLabel
    }()

    // 分割线
    private lazy var lineView : UIView = {
        var lineView : UIView = UIView()
        lineView.backgroundColor = UIColor.lightGrayColor()
        return lineView
    }()
    
    // 我的收藏
    private lazy var collectionLabel : UILabel = {
        var collectionLabel: UILabel = UILabel()
        collectionLabel.textAlignment = .Center
        collectionLabel.text = "我的收藏"
        collectionLabel.font = UIFont.customFont_FZLTXIHJW(fontSize: UIConstant.UI_FONT_14)
        collectionLabel.textColor = UIColor.blackColor()
        return collectionLabel
    }()
    // 我的评论
    private lazy var commentLabel : UILabel = {
        var commentLabel : UILabel = UILabel()
        commentLabel.textAlignment = .Center
        commentLabel.text = "我的评论"
        commentLabel.font = UIFont.customFont_FZLTXIHJW(fontSize: UIConstant.UI_FONT_14)
        commentLabel.textColor = UIColor.blackColor()
        return commentLabel
    }()
}
