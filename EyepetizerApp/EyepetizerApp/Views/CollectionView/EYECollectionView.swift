//
//  EYECollectionView.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/21.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class EYECollectionLayout: UICollectionViewFlowLayout {
    override init () {
        super.init()
        let itemHeight = 200*UIConstant.SCREEN_WIDTH/UIConstant.IPHONE5_WIDTH
        itemSize = CGSize(width: UIConstant.SCREEN_WIDTH, height: itemHeight)
        sectionInset = UIEdgeInsetsZero
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class EYECollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = UIColor.whiteColor()
        // 注册cell
        registerClass(EYEChoiceCell.self, forCellWithReuseIdentifier: EYEChoiceCell.reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
