//
//  TopicVideoView.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/12/8.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit
import SDWebImage

class TopicVideoView: UIView {
    @IBOutlet weak var playCountLabel: UILabel!

    @IBOutlet weak var videoTimeLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var topic:topic?{
        didSet{
            guard (topic?.image2) != nil  else {
                return
            }
            //SDWebImage 动态图不能播？有时间在看源码
            //加载进度显示，等有时间
            imageView.sd_setImage(with: NSURL(string: (topic?.image2)!) as URL?)
            
            playCountLabel.text = "\((topic?.playcount)!)播放"
            let minute = String(format: "%02d", (topic?.videotime)! / 60)
            let second = String(format: "%02d", (topic?.videotime)! % 60)

            videoTimeLabel.text = minute + ":" + second
        }
    }
    override func awakeFromNib() {
        // 从xib中加载进来的控件的autoresizingMask默认是UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
        autoresizingMask = []
        self.imageView.isUserInteractionEnabled = true

    }
}
