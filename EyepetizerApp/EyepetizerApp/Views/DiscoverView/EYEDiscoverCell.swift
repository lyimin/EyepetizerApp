//
//  EYEDiscoverCell.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/17.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import Foundation

class EYEDiscoverCell : UICollectionViewCell, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(backgroundImageView)
        self.contentView.addSubview(coverButton)
        self.contentView.addSubview(titleLabel)
        
        backgroundImageView.snp_makeConstraints { [unowned self](make) -> Void in
            make.edges.equalTo(self.contentView)
        }
        coverButton.snp_makeConstraints { [unowned self](make) -> Void in
            make.edges.equalTo(self.contentView)
        }
        titleLabel.snp_makeConstraints { [unowned self](make) -> Void in   
            make.leading.trailing.equalTo(self.contentView)
            make.height.equalTo(20)
            make.centerY.equalTo(self.contentView.center).offset(0)
        }
    }
    
    var model : EYEDiscoverModel! {
        didSet {
            self.backgroundImageView.yy_setImageWithURL(NSURL(string: model.bgPicture)!, options: .ProgressiveBlur)
            self.titleLabel.text = model.name
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: --------------------------- Getter or Setter --------------------------
    /// 背景图片
    private var backgroundImageView : UIImageView = {
        var backgroundImageView : UIImageView = UIImageView ()
        return backgroundImageView
    }()
    
    /// 黑色图层
    private lazy var coverButton : UIButton = {
        var coverButton : UIButton = UIButton()
        coverButton.userInteractionEnabled = false
        coverButton.backgroundColor = UIColor.blackColor()
        coverButton.alpha = 0.3
        return coverButton
    }()
    /// 标题
    private var titleLabel : UILabel = {
        var titleLabel : UILabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.customFont_FZLTZCHJW(fontSize: UIConstant.UI_FONT_16)
        return titleLabel
    }()
}