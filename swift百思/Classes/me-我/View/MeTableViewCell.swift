//
//  MeTableViewCell.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/30.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

class MeTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.textColor = UIColor.darkGray
        accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        self.backgroundView = UIImageView(image: UIImage(named: "mainCellBackground"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageView?.image == nil {
            return
        }
        imageView?.frame.origin.y = 5
        imageView?.frame.size.height = contentView.frame.size.height - 10
        imageView?.frame.size.width = (imageView?.frame.size.height)!
        textLabel?.frame.origin.x = (self.imageView?.frame.maxY)! + 20
        
        
    }

}
