//
//  SameHeightLayout.swift
//  SameHeightLayout
//
//  Created by nathan on 16/1/10.
//  Copyright © 2016年 nathanwhy. All rights reserved.
//

import UIKit

import UIKit

protocol SameHeightLayoutDelegate {
    func collectionView(collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGSize
}

class SameHeightLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var photoRatio: CGFloat = 0
    var photoSize: CGSize = CGSizeZero
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! SameHeightLayoutAttributes
        copy.photoSize = photoSize
        copy.photoRatio = photoRatio
        return copy
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let attributes = object as? SameHeightLayoutAttributes {
            if CGSizeEqualToSize(attributes.photoSize, photoSize) {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class SameHeightLayout: UICollectionViewLayout {
      
    var cellPadding: CGFloat = 0
    var delegate: SameHeightLayoutDelegate!
    var numberOfColumns = 1
    var maxNumberAtLine = 3
    
    private var cache = [SameHeightLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private var width: CGFloat {
        get {
            let insets = collectionView!.contentInset
            return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
        }
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return SameHeightLayoutAttributes.self
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepareLayout() {
        if cache.isEmpty {
            
            let maxRatio:CGFloat = 3.0
            let minRatio:CGFloat = 0.3
            var sizeArray = [SameHeightLayoutAttributes]()
            
            var rowWeight = 0
            var yOffset: CGFloat = 0
            var ratioSum: CGFloat = 0
            let maxItemWeight = 2 * maxNumberAtLine - 1
            
            for item in 0..<collectionView!.numberOfItemsInSection(0) {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let photoSize = delegate.collectionView(collectionView!, sizeForPhotoAtIndexPath: indexPath, withWidth: width)
                let photoRatio = photoSize.width / photoSize.height
                
                let attributes = SameHeightLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.photoSize = photoSize
                attributes.photoRatio = photoRatio
                cache.append(attributes)
                sizeArray.append(attributes)
                
                if photoRatio > maxRatio {
                    ratioSum += maxRatio;
                    rowWeight += maxItemWeight
                }else if photoRatio > 1{
                    ratioSum += photoRatio;
                    rowWeight += 3
                }else if photoRatio > minRatio{
                    ratioSum += photoRatio;
                    rowWeight += 2
                }else{
                    ratioSum += minRatio;
                    rowWeight += 2
                }
                
                if rowWeight > maxItemWeight {
                    var xOffset: CGFloat = 0
                    let itemHeight = width / ratioSum
                    for item in sizeArray {
                        let itemWidth  = itemHeight * item.photoRatio
                        let itemFrame  = CGRectMake(xOffset, yOffset, itemWidth, itemHeight)
                        item.frame = CGRectInset(itemFrame, cellPadding, cellPadding)
                        xOffset += itemWidth
                    }
                    yOffset += itemHeight
                    contentHeight += itemHeight
                    rowWeight = 0
                    ratioSum = 0
                    sizeArray.removeAll()
                }
            }
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter{ CGRectIntersectsRect($0.frame, rect) }
    }
}
