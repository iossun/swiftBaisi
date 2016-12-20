//
//  UIImageView + Extension.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/12/2.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

extension UIImage {
    class func circleImage(named:String) -> UIImage{
        return  (UIImage(named: named)?.circleImage())!
    }
    
   func circleImage() -> UIImage? {
    //开启视图上下文
    UIGraphicsBeginImageContext(self.size)
    
    //上下文
    let ctx = UIGraphicsGetCurrentContext()
    
    let  rect = CGRect(x: 0, y: 0, width: self.size.width, height: (self.size.height))
    ctx!.addEllipse(in: rect);
    ctx?.clip()
    draw(in: rect)
    
    let image =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext()
    
    return image
    }
    
    
    
    
    
}
