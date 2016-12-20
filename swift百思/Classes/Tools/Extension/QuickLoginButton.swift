//
//  SMQuickLoginButton.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/23.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

class QuickLoginButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        titleLabel?.textAlignment = NSTextAlignment.center
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame.origin.y = 0
        imageView?.center.x = frame.size.width * 0.5
        
        titleLabel?.frame.origin.x = 0
        titleLabel?.frame.origin.y = (imageView?.frame.maxY)!
        titleLabel?.frame.size.width = frame.size.width
        titleLabel?.frame.size.height = frame.size.height - (imageView?.frame.size.height)!
        
      }

}
