//
//  SeeBigViewController.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/12/26.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit
import SDWebImage

class SeeBigViewController: UIViewController,UIScrollViewDelegate {

    var topic:topic!
    var imageView:UIImageView?
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let scrollView = UIScrollView.init()
        scrollView.delegate = self;
        scrollView.frame = UIScreen.main.bounds
        self.view.insertSubview(scrollView, at: 0);
        
        let imageView = UIImageView.init()
        imageView.sd_setImage(with: NSURL(string: (topic?.image2)!) as URL?, placeholderImage: nil, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: {
            (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
            if(image == nil){
                return
            }
            self.saveButton.isEnabled = true
          })
        scrollView.addSubview(imageView)
        imageView.frame.size.width = scrollView.frame.size.width
        imageView.frame.size.height = CGFloat(self.topic.height) * CGFloat(imageView.frame.size.width) / CGFloat(topic.width)
        imageView.frame.origin.x = 0;
        
        if (imageView.frame.size.height >= scrollView.frame.size.height) { // 图片高度超过整个屏幕
            imageView.frame.origin.y = 0;
            // 滚动范围
            scrollView.contentSize = CGSize(width: 0, height: imageView.frame.size.height)//CGSizeMake(0, imageView.frame.size.height);
        } else { // 居中显示
            imageView.center.y = scrollView.frame.size.height * 0.5;
        }
        self.imageView = imageView;
        
        // 缩放比例
        let scale =  CGFloat(self.topic.width) / CGFloat(imageView.frame.size.height);
        if (scale > 1.0) {
            scrollView.maximumZoomScale = scale;
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:  - <UIScrollViewDelegate>
    /**
     *  返回一个scrollView的子控件进行缩放
     */

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
