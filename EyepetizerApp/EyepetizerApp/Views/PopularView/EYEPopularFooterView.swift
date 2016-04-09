//
//  EYEPopularFooterView.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/29.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class EYEPopularFooterView: UICollectionReusableView, Reusable {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { [unowned self](make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel : UILabel = {
        var titleLabel = UILabel()
        titleLabel.text = "-The End-"
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.customFont_Lobster()
        return titleLabel
    }()
}
