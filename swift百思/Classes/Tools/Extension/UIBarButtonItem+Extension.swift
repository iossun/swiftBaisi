//
//  UIBarButtonItem+Extension.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/22.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit


extension UIBarButtonItem{
    convenience init(target: AnyObject,imageName:String,highImage:String, action: Selector, for controlEvents: UIControlEvents) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControlState.normal)
        btn.setImage(UIImage(named: highImage), for: UIControlState.highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: controlEvents)
        self.init(customView:btn)
    }
}
