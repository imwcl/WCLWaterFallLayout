//
//  WCLWaterFallLayout.swift
//  HotLine
//
// **************************************************
// *                                  _____         *
// *         __  _  __     ___        \   /         *
// *         \ \/ \/ /    / __\       /  /          *
// *          \  _  /    | (__       /  /           *
// *           \/ \/      \___/     /  /__          *
// *                               /_____/          *
// *                                                *
// **************************************************
//  Github  :https://github.com/631106979
//  HomePage:https://imwcl.com
//  CSDN    :http://blog.csdn.net/wang631106979
//
//  Created by 王崇磊 on 16/9/14.
//  Copyright © 2016年 王崇磊. All rights reserved.
//
// @class WCLWaterFallLayout
// @abstract 瀑布流的layout
// @discussion 瀑布流的layout
//

import UIKit

@objc protocol WCLWaterFallLayoutDelegate {
    //waterFall的列数
    func columnOfWaterFall(_ collectionView: UICollectionView) -> Int
    //每个item的高度
    func waterFall(_ collectionView: UICollectionView, layout waterFallLayout: WCLWaterFallLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
}


class WCLWaterFallLayout: UICollectionViewLayout {
    
    //代理
    weak var delegate: WCLWaterFallLayoutDelegate?
    //行间距
    @IBInspectable var lineSpacing: CGFloat   = 0
    //列间距
    @IBInspectable var columnSpacing: CGFloat = 0
    //section的top
    @IBInspectable var sectionTop: CGFloat    = 0 {
        willSet {
            sectionInsets.top = newValue
        }
    }
    //section的Bottom
    @IBInspectable var sectionBottom: CGFloat  = 0 {
        willSet {
            sectionInsets.bottom = newValue
        }
    }
    //section的left
    @IBInspectable var sectionLeft: CGFloat   = 0 {
        willSet {
            sectionInsets.left = newValue
        }
    }
    //section的right
    @IBInspectable var sectionRight: CGFloat  = 0 {
        willSet {
            sectionInsets.right = newValue
        }
    }
    //section的Insets
    @IBInspectable var sectionInsets: UIEdgeInsets      = UIEdgeInsets.zero
    //每行对应的高度
    private var columnHeights: [Int: CGFloat]                  = [Int: CGFloat]()
    private var attributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    //MARK: Initial Methods
    init(lineSpacing: CGFloat, columnSpacing: CGFloat, sectionInsets: UIEdgeInsets) {
        super.init()
        self.lineSpacing      = lineSpacing
        self.columnSpacing    = columnSpacing
        self.sectionInsets    = sectionInsets
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Public Methods
    
    
    //MARK: Override
    override var collectionViewContentSize: CGSize {
        var maxHeight: CGFloat = 0
        for height in columnHeights.values {
            if height > maxHeight {
                maxHeight = height
            }
        }
        return CGSize.init(width: collectionView?.frame.width ?? 0, height: maxHeight + sectionInsets.bottom)
    }
    
    override func prepare() {
        super.prepare()
        guard collectionView != nil else {
            return
        }
        if let columnCount = delegate?.columnOfWaterFall(collectionView!) {
            for i in 0..<columnCount {
                columnHeights[i] = sectionInsets.top
            }
        }
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        attributes.removeAll()
        for i in 0..<itemCount {
            if let att = layoutAttributesForItem(at: IndexPath.init(row: i, section: 0)) {
                attributes.append(att)
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let collectionView = collectionView {
            //根据indexPath获取item的attributes
            let att = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
            //获取collectionView的宽度
            let width = collectionView.frame.width
            if let columnCount = delegate?.columnOfWaterFall(collectionView) {
                guard columnCount > 0 else {
                    return nil
                }
                //item的宽度 = (collectionView的宽度 - 内边距与列间距) / 列数
                let totalWidth  = (width - sectionInsets.left - sectionInsets.right - (CGFloat(columnCount) - 1) * columnSpacing)
                let itemWidth   = totalWidth / CGFloat(columnCount)
                //获取item的高度，由外界计算得到
                let itemHeight  = delegate?.waterFall(collectionView, layout: self, heightForItemAt: indexPath) ?? 0
                //找出最短的那一列
                var minIndex = 0
                for column in columnHeights {
                    if column.value < columnHeights[minIndex] ?? 0 {
                        minIndex = column.key
                    }
                }
                //根据最短列的列数计算item的x值
                let itemX  = sectionInsets.left + (columnSpacing + itemWidth) * CGFloat(minIndex)
                //item的y值 = 最短列的最大y值 + 行间距
                let itemY  = (columnHeights[minIndex] ?? 0) + lineSpacing
                //设置attributes的frame
                att.frame  = CGRect.init(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
                //更新字典中的最大y值
                columnHeights[minIndex] = att.frame.maxY
            }
            return att
        }
        return nil
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}
