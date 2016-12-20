//
//  MeSquareButton.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/29.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit
import SDWebImage

class MeSquareButton: UIButton {
    var square:MeSquare? {
        didSet{
            setTitle(square?.name, for: UIControlState.normal)
            sd_setImage(with: URL(string: (square?.icon)!), for: UIControlState.normal, placeholderImage: UIImage(named:"setup-head-default"))
        }
    }
    
    /// 通过代码创建会调用
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        setTitleColor(UIColor.black, for: UIControlState.normal)
        setBackgroundImage(UIImage(named:"mainCellBackground"), for: UIControlState.normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //重新布局
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame.origin.y = frame.size.height * 0.15
        imageView?.frame.size.height = frame.size.height * 0.5
        imageView?.frame.size.width = (imageView?.frame.size.height)!
        imageView?.center.x = frame.size.width * 0.5
        
        titleLabel?.frame.origin.x = 0
        titleLabel?.frame.origin.y = (imageView?.frame.maxY)!
        titleLabel?.frame.size.width = frame.size.width
        titleLabel?.frame.size.height = frame.size.height - (imageView?.frame.size.height)!
        
    }

    
}
