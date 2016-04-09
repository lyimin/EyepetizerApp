//
//  EYEVideoDetailView.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/23.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

protocol EYEVideoDetailViewDelegate {
    // 点击播放按钮
    func playImageViewDidClick()
    // 点击返回按钮
    func backBtnDidClick()
}

class EYEVideoDetailView: UIView {

    //MARK: --------------------------- Life Cycle --------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.addSubview(albumImageView)
        self.addSubview(blurImageView)
        self.addSubview(blurView)
        self.addSubview(backBtn)
        self.addSubview(playImageView)
        self.addSubview(videoTitleLabel)
        self.addSubview(lineView)
        self.addSubview(classifyLabel)
        self.addSubview(describeLabel)
        self.addSubview(bottomToolView)
        // 添加底部item
        
        let itemSize: CGFloat = 80
        for i in 0..<bottomImgArray.count {
            let btn = BottomItemBtn(frame: CGRect(x: UIConstant.UI_MARGIN_15+CGFloat(i)*itemSize, y: 0, width: itemSize, height: bottomToolView.height), title: "0", image: bottomImgArray[i]!)
            itemArray.append(btn)
            bottomToolView.addSubview(btn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model : ItemModel! {
        didSet {
//            self.albumImageView.yy_setImageWithURL(NSURL(string: model.feed), placeholder: UIImage.colorImage(UIColor.lightGrayColor(), size: albumImageView.size))
//            self.albumImageView.yy_setImageWithURL(NSURL(string: model.feed), options: .ProgressiveBlur)
            self.blurImageView.yy_setImageWithURL(NSURL(string:model.feed), placeholder: UIImage(named: "7e42a62065ef37cfa233009fb364fd1e_0_0"))
            videoTitleLabel.animationString = model.title
            self.classifyLabel.text = model.subTitle
            
            // 显示底部数据
            self.itemArray.first?.setTitle("\(model.collectionCount)", forState: .Normal)
            self.itemArray[1].setTitle("\(model.shareCount)", forState: .Normal)
            self.itemArray[2].setTitle("\(model.replyCount)", forState: .Normal)
            self.itemArray.last?.setTitle("缓存", forState: .Normal)
            
            // 计算宽度
            self.describeLabel.text = model.description
            let size = self.describeLabel.boundingRectWithSize(describeLabel.size)
            self.describeLabel.frame = CGRectMake(describeLabel.x, describeLabel.y, size.width, size.height)
        }
    }
    //MARK: --------------------------- Event response --------------------------
    /**
     点击播放按钮
     */
    @objc private func playImageViewDidClick() {
        delegate.playImageViewDidClick()
    }
    
    /**
     点击返回按钮
     */
    @objc private func backBtnDidClick() {
        delegate.backBtnDidClick()
    }
    
    //MARK: --------------------------- Getter or Setter --------------------------
    // 代理
    var delegate: EYEVideoDetailViewDelegate!
    // 图片
    lazy var albumImageView : UIImageView = {
        // 图片大小 1242 x 777
        // 6 621*388.5
        // 5 621*388.5
        let photoW : CGFloat = 1222.0
        let photoH : CGFloat = 777.0
        let albumImageViewH = self.height*0.6
        let albumImageViewW = photoW*albumImageViewH/photoH
        let albumImageViewX = (albumImageViewW-self.width)*0.5
//        let imageViewH = self.width*photoH / UIConstant.IPHONE6_WIDTH
        var albumImageView = UIImageView(frame: CGRect(x: -albumImageViewX, y: 0, width: albumImageViewW, height: albumImageViewH))
        albumImageView.clipsToBounds = true
        albumImageView.contentMode = .ScaleAspectFill
        albumImageView.userInteractionEnabled = true
        return albumImageView
    }()
    
    // 模糊背景
    lazy var blurImageView : UIImageView = {
        var blurImageView = UIImageView(frame: CGRect(x: 0, y: self.albumImageView.height, width: self.width, height: self.height-self.albumImageView.height))
        return blurImageView
    }()
    
    lazy var blurView : UIVisualEffectView = {
        let blurEffect : UIBlurEffect = UIBlurEffect(style: .Light)
        var blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.blurImageView.frame
        return blurView
    }()
    
    // 返回按钮
    lazy var backBtn : UIButton = {
        var backBtn = UIButton(frame: CGRect(x: UIConstant.UI_MARGIN_10, y: UIConstant.UI_MARGIN_20, width: 40, height: 40))
        backBtn.setImage(UIImage(named: "play_back_full"), forState: .Normal)
        backBtn.addTarget(self, action: #selector(EYEVideoDetailView.backBtnDidClick), forControlEvents: .TouchUpInside)
        return backBtn
    }()
    // 播放按钮
    lazy var playImageView : UIImageView = {
        var playImageView = UIImageView(image: UIImage(named: "ic_action_play"))
        playImageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        playImageView.center = self.albumImageView.center
        playImageView.contentMode = .ScaleAspectFit
        playImageView.viewAddTarget(self, action: #selector(EYEVideoDetailView.playImageViewDidClick))
        return playImageView
    }()
    
    // 标题
    lazy var videoTitleLabel : EYEShapeView = {
        let rect = CGRect(x: UIConstant.UI_MARGIN_10, y: CGRectGetMaxY(self.albumImageView.frame)+UIConstant.UI_MARGIN_10, width: self.width-2*UIConstant.UI_MARGIN_10, height: 20)
        let font = UIFont.customFont_FZLTZCHJW(fontSize: UIConstant.UI_FONT_16)
        var videoTitleLabel = EYEShapeView(frame: rect)
        videoTitleLabel.font = font
        videoTitleLabel.fontSize = UIConstant.UI_FONT_16
        return videoTitleLabel
    }()
    
    // 分割线
    private lazy var lineView : UIView = {
        var lineView = UIView(frame: CGRect(x: UIConstant.UI_MARGIN_10, y: CGRectGetMaxY(self.videoTitleLabel.frame)+UIConstant.UI_MARGIN_10, width: self.width-2*UIConstant.UI_MARGIN_10, height: 0.5))
        lineView.backgroundColor = UIColor.whiteColor()
        return lineView
    }()
    
    // 分类/时间
    lazy var classifyLabel : UILabel = {
        var classifyLabel = UILabel(frame: CGRect(x: UIConstant.UI_MARGIN_10, y: CGRectGetMaxY(self.lineView.frame)+UIConstant.UI_MARGIN_10, width: self.width-2*UIConstant.UI_MARGIN_10, height: 20))
        classifyLabel.textColor = UIColor.whiteColor()
        classifyLabel.font = UIFont.customFont_FZLTXIHJW(fontSize: UIConstant.UI_FONT_13)
        return classifyLabel
    }()
    
    // 描述
    lazy var describeLabel : UILabel = {
        var describeLabel = UILabel(frame: CGRect(x: UIConstant.UI_MARGIN_10, y: CGRectGetMaxY(self.classifyLabel.frame)+UIConstant.UI_MARGIN_10, width: self.width-2*UIConstant.UI_MARGIN_10, height: 200))
        describeLabel.numberOfLines = 0
        describeLabel.textColor = UIColor.whiteColor()
        describeLabel.font = UIFont.customFont_FZLTXIHJW(fontSize: UIConstant.UI_FONT_13)
        return describeLabel
    }()
    // 底部 喜欢 分享 评论 缓存
    lazy var bottomToolView : UIView = {
        var bottomToolView = UIView(frame: CGRect(x: 0, y: self.height-50, width: self.width, height: 30))
        bottomToolView.backgroundColor = UIColor.clearColor()
        return bottomToolView
    }()
    
    private var itemArray: [BottomItemBtn] = [BottomItemBtn]()
    // 底部图片数组
    private var bottomImgArray = [UIImage(named: "ic_action_favorites_without_padding"), UIImage(named: "ic_action_share_without_padding"), UIImage(named: "ic_action_reply_nopadding"), UIImage(named: "action_download_cut")]
    
        /// 底部item
    private class BottomItemBtn : UIButton {
        // 标题
        private var title: String!
        // 图片
        private var image: UIImage!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = UIColor.clearColor()
            self.titleLabel?.font = UIFont.customFont_FZLTXIHJW()
            self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        
        convenience init(frame: CGRect, title: String, image: UIImage) {
            self.init(frame: frame)
            self.title = title
            self.image = image
            
            self.setImage(image, forState: .Normal)
            self.setTitle(title, forState: .Normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /**
         文字的frame
         */
        private override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
            return CGRect(x: self.height-8, y: 0, width: self.width-self.height+8, height: self.height)
        }
        
        /**
         图片的frame
         */
        private override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
            return CGRect(x: 0, y: 8, width: self.height-16, height: self.height-16)
        }
        
    }
}

