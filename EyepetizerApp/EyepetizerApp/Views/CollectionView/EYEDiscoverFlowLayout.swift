//
//  EYEChoiceFlowLayout.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/16.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit


class EYEDiscoverFlowLayout : UICollectionViewFlowLayout {
    private var contentHeight: CGFloat = 0
    //  获取collectionView 高度
    private var width: CGFloat {
        get {
            let insets = collectionView!.contentInset
            return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
        }
    }
    
    // collectionView section count
    private var numberOfSection : Int! {
        return collectionView?.numberOfSections() ?? 0
    }
    
    // 滚动区域
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
    }
}