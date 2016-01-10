//
//  UIImage+Decompression.swift
//  SameHeightLayout
//
//  Created by nathan on 16/1/10.
//  Copyright © 2016年 nathanwhy. All rights reserved.
//

import UIKit

extension UIImage {
    
    var decompressedImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        drawAtPoint(CGPointZero)
        let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return decompressedImage
    }
}