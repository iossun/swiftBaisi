//
//  TopicPictureView.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/12/7.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit
import SDWebImage

class TopicPictureView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var seeBigButton: UIButton!
    
    @IBOutlet weak var gifView: UIImageView!
    var topic:topic?{
        didSet{
            guard (topic?.image2) != nil  else {
                return
            }
            //SDWebImage 动态图不能播？有时间在看源码 
            //加载进度显示，等有时间
            imageView.sd_setImage(with: NSURL(string: (topic?.image2)!) as URL?, placeholderImage: nil, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: {
                (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                
            })
            gifView.isHidden = ((topic?.is_gif)! == 0)
            
            guard topic?.bigPicture != nil else {
                return
            }
            if (topic?.bigPicture)! == 1 {//超长图片
                seeBigButton.isHidden = false
                imageView.clipsToBounds = true;
                imageView.contentMode = UIViewContentMode.top
            }else{
                seeBigButton.isHidden = true
                imageView.clipsToBounds = false;
                imageView.contentMode = UIViewContentMode.scaleToFill

            }
 
       }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // 从xib中加载进来的控件的autoresizingMask默认是UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
          autoresizingMask = []
          self.imageView.isUserInteractionEnabled = true
       }
    
    @IBAction func seeBigButtonClick(_ sender: Any) {
    }
}
