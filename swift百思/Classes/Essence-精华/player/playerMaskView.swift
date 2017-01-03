//
//  playerMaskView.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/12/26.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit
import AVFoundation

class playerMaskView: UIView {

    
    /** 开始播放按钮 */
    var startBtn:UIButton!
    /** 当前播放时长label */
    var currentTimeLabel:UILabel!
    /** 视频总时长label */
    var totalTimeLabel:UILabel!
    /** 缓冲进度条 */
    var progressView:UIProgressView!
    /** 滑杆 */
    var videoSlider:UISlider!
    /** 全屏按钮 */
    var fullScreenBtn:UIButton!
    var lockBtn:UIButton!
    /** 音量进度 */
    var volumeProgress:UIProgressView!
    
    /** 系统菊花 */
    var activity:UIActivityIndicatorView!
    
    /** bottom渐变层*/
    var bottomGradientLayer: CAGradientLayer!
    /** top渐变层 */
    var topGradientLayer:CAGradientLayer!
    /** bottomView*/
    var bottomImageView:UIImageView!
    /** topView */
    var topImageView:UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()

  
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
    topImageView = UIImageView()
    bottomImageView = UIImageView()
    bottomImageView.isUserInteractionEnabled = true
    
    startBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    startBtn.setImage(#imageLiteral(resourceName: "kr-video-player-play"), for: UIControlState.normal)
    startBtn.setImage(#imageLiteral(resourceName: "kr-video-player-pause"), for: UIControlState.selected)
    fullScreenBtn = UIButton()
    fullScreenBtn.setImage(#imageLiteral(resourceName: "kr-video-player-fullscreen"), for: UIControlState.normal)
    currentTimeLabel = UILabel.init(frame: CGRect(x: 50, y: 10, width: 60, height: 30))
    currentTimeLabel.text = "00:00"
    currentTimeLabel.textColor = UIColor.white
    currentTimeLabel.textAlignment = NSTextAlignment.center
    currentTimeLabel.font = UIFont.systemFont(ofSize: 15)
    totalTimeLabel = UILabel();
    totalTimeLabel.textAlignment = NSTextAlignment.center;
    totalTimeLabel.font = UIFont.systemFont(ofSize: 15)
    totalTimeLabel.textColor = UIColor.white
    totalTimeLabel.text = "00:00";
    
    
    progressView = UIProgressView()
    progressView.progressTintColor    = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
    progressView.trackTintColor       = UIColor.clear
    
    volumeProgress = UIProgressView()
    volumeProgress.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI_2));
    volumeProgress.progressTintColor    = UIColor.white
    volumeProgress.trackTintColor       = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
    
    
    // 设置slider
    videoSlider = UISlider();
    videoSlider.setThumbImage(#imageLiteral(resourceName: "slider"), for: UIControlState.normal)
    
    videoSlider.minimumTrackTintColor = UIColor.white
    videoSlider.maximumTrackTintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
    
    self.addSubview(topImageView)
    self.addSubview(bottomImageView)
    // 初始化渐变层
    self.initCAGradientLayer()
    
    
    activity = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    bottomImageView.addSubview(self.startBtn)
    bottomImageView.addSubview(self.fullScreenBtn)
    bottomImageView.addSubview(self.currentTimeLabel)
    
    bottomImageView.addSubview(self.totalTimeLabel)
    
    bottomImageView.addSubview(self.progressView)
    
    bottomImageView.addSubview(self.videoSlider)
    
    self.addSubview(self.volumeProgress)
    
    self.addSubview(self.activity)
    do {
        try AVAudioSession.sharedInstance().setActive(true)
    } catch let error as NSError {
        // 发生了错误
        print(error.localizedDescription)
    }

    NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    func volumeChanged(notification:NSNotification) {
        let coc = notification.userInfo;
        SMLog(message: coc);
        let valueStr = notification.userInfo?["AVSystemController_AudioVolumeNotificationParameter"];
        volumeProgress.progress = valueStr as! Float
        

    }
    
     func initCAGradientLayer()
    {
    //初始化Bottom渐变层
    bottomGradientLayer = CAGradientLayer()
    bottomImageView.layer.addSublayer(bottomGradientLayer)
    //设置渐变颜色方向
    bottomGradientLayer.startPoint = CGPoint(x: 0, y: 0)
    bottomGradientLayer.endPoint   = CGPoint(x: 0, y: 1)
    //设定颜色组
    bottomGradientLayer.colors  = [UIColor.clear.cgColor,
    UIColor.black.cgColor]
    //设定颜色分割点
    bottomGradientLayer.locations  = [0.0,1.0];
    
    
    //初始Top化渐变层
    topGradientLayer  = CAGradientLayer();
    topImageView.layer.addSublayer(topGradientLayer)
    //设置渐变颜色方向
    topGradientLayer.startPoint    = CGPoint(x: 1, y: 0)
    topGradientLayer.endPoint      = CGPoint(x: 1, y: 1)
    //设定颜色组
    topGradientLayer.colors        = [UIColor.black.cgColor,UIColor.clear.cgColor]
    //设定颜色分割点
    topGradientLayer.locations     = [0.0,1.0]
    
    }
    
    override func layoutSubviews() {
        
       let width = self.frame.size.width;
       let height = self.frame.size.height;
        
        topImageView.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        bottomImageView.frame = CGRect(x: 0, y: height-50, width: width, height: 50)
        bottomGradientLayer.frame = bottomImageView.bounds;
        topGradientLayer.frame    = topImageView.bounds;
        
        fullScreenBtn.frame = CGRect(x: width-50, y: 0, width: 50, height: 50)
        let progressWidth = width-2*(startBtn.frame.size.width + currentTimeLabel.frame.size.width);
        progressView.frame = CGRect(x: 0, y: 0, width: progressWidth, height: 20)
        progressView.center = CGPoint(x:width/2, y:25)
        totalTimeLabel.frame = CGRect(x: width-110, y: 10, width: 60, height: 30)
        videoSlider.frame = self.progressView.frame;
        activity.center = CGPoint(x:width/2, y:height/2)
        volumeProgress.bounds = CGRect(x: 0, y: 0, width: 100, height: 30)
        volumeProgress.center = CGPoint(x:40, y:height/2)

    }
}
