//
//  PhotoViewController.swift
//  SameHeightLayout
//
//  Created by nathan on 16/1/10.
//  Copyright © 2016年 nathanwhy. All rights reserved.
//

import UIKit

class PhotoViewController: UICollectionViewController {
    
    var photos: [UIImage] = []
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var photoNames: [String] = []
        for i in 0...48{
            photoNames.append(String(i) + ".jpg")
        }
        photos = photoNames.flatMap({ UIImage(named: $0 )})
                           .map({ $0.decompressedImage })
        
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        
        let layout = collectionViewLayout as! SameHeightLayout
        layout.cellPadding = 5
        layout.delegate = self
        layout.numberOfColumns = 2
    }
}

extension PhotoViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        cell.PhotoView.image = photos[indexPath.item]
        return cell
    }
}

extension PhotoViewController: SameHeightLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGSize {
        let photoSize = photos[indexPath.item].size
        return photoSize
    }
}