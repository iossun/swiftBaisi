//
//  player.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/12/26.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

public enum PanDirection : Int {
    case PanDirectionHorizontalMoved = 0,//横向移动
    PanDirectionVerticalMoved = 1   //纵向移动

}

public enum ZFPlayerState : Int {
    case
    ZFPlayerStateBuffering = 0,  //缓冲中
    ZFPlayerStatePlaying = 1,    //播放中
    ZFPlayerStateStopped = 2,    //停止播放
    ZFPlayerStatePause  = 3      //暂停播放
    
}



class player: UIView,UIGestureRecognizerDelegate{

    var player:AVPlayer!
    var playerItme:AVPlayerItem!
    var playerLayer:AVPlayerLayer!
    
    var playMaskView:playerMaskView!
    
    var smallFrame:CGRect!
    var bigFrame:CGRect!
    
    /** 定义一个实例变量，保存枚举值 */
    var panDirection:PanDirection! = PanDirection.PanDirectionHorizontalMoved
    var playState:ZFPlayerState!{
        didSet{
            if (playState != ZFPlayerState.ZFPlayerStateBuffering) {
                self.playMaskView.activity.stopAnimating()
            }
        }
    }
    
    
    var isDragSlider:Bool = false
    /** 是否被用户暂停 */
    var isPauseByUser:Bool = false
    
    /** 滑杆 */
    var volumeViewSlider:UISlider?
    
    var isBuffering = false;
    
    var videoURL:NSURL?{
        didSet{
            //将之前的监听时间移除掉。
//            guard playerItme != nil else {
//                return
//            }
            if playerItme != nil {
                playerItme.removeObserver(self, forKeyPath: "status")
                playerItme.removeObserver(self, forKeyPath: "loadedTimeRanges")
                playerItme.removeObserver(self, forKeyPath: "playbackBufferEmpty")
                playerItme.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
                self.playerItme = nil;

            }
            
            
            
            playerItme = AVPlayerItem(url: videoURL as! URL)
            player.replaceCurrentItem(with: playerItme)
            // AVPlayer播放完成通知
            NotificationCenter.default.addObserver(self, selector: #selector(moviePlayDidEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)

            // 监听播放状态
            playerItme.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        
            // 监听loadedTimeRanges属性
            playerItme.addObserver(self , forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
            // Will warn you when your buffer is empty
            playerItme.addObserver(self , forKeyPath: "isPlaybackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
            // Will warn you when your buffer is good to go again.

            playerItme.addObserver(self , forKeyPath: "isPlaybackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
            
            player.play()
            playMaskView.startBtn.isSelected = true;
            playState = ZFPlayerState.ZFPlayerStatePlaying;
            playMaskView.activity.startAnimating()
        }
    }


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI(frame: CGRect) {
        smallFrame = frame
        
        bigFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        player = AVPlayer.init(url: NSURL.init(string: "") as! URL)
        playerLayer = AVPlayerLayer.init(player: player)
        
        //控制内容的填充方式 //代优化
        if(playerLayer.videoGravity == AVLayerVideoGravityResizeAspect){
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        }else{
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        }
        layer.insertSublayer(playerLayer, at: 0)
       // playerLayer.frame = frame
        
        playMaskView = playerMaskView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        addSubview(playMaskView)
        
        
        //[self.maskView.fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        playMaskView.fullScreenBtn.addTarget(self, action: #selector(fullScreenBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        
        // 播放按钮点击事件
        playMaskView.startBtn.addTarget(self, action: #selector(startAction(btn:)), for: UIControlEvents.touchUpInside)
        // slider开始滑动事件
        playMaskView.videoSlider.addTarget(self, action: #selector( progressSliderTouchBegan(slider:)), for: UIControlEvents.touchDown)

        // slider滑动中事件
        playMaskView.videoSlider.addTarget(self, action: #selector(progressSliderValueChanged(slider:)), for: UIControlEvents.valueChanged)
        // slider结束滑动事件
         playMaskView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded(slider:)), for: UIControlEvents.touchUpInside)
        playMaskView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded(slider:)), for: UIControlEvents.touchUpInside)
        playMaskView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded(slider:)), for: UIControlEvents.touchUpOutside)
        
        // app退到后台
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        // app进入前台
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterPlayGround), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        listeningRotating()
        setTheProgressOfPlayTime()
        getVolumeVolue()
        // 添加平移手势，用来控制音量、亮度、快进快退
        let pan = UIPanGestureRecognizer.init(target: self, action:#selector(panDirection(pan:)))
        pan.delegate   = self;
        self.addGestureRecognizer(pan)
        
    }
    
    
    func fullScreenBtnClick(btn:UIButton){
        btn.isSelected = !btn.isSelected;
        
        if (btn.isSelected == true) {
            interfaceOrientation(orientation:UIInterfaceOrientation.landscapeRight)
        }else{
            interfaceOrientation(orientation:UIInterfaceOrientation.portrait)
        }
  
    }
    
    
    private func interfaceOrientation(orientation:UIInterfaceOrientation){
        
          UIDevice.current.setValue(Int(orientation.rawValue), forKey: "orientation")
       
    }
    
    func startAction(btn:UIButton) {
        btn.isSelected = !btn.isSelected;
        if (btn.isSelected) {
            isPauseByUser = false
            player.play()
            self.playState = ZFPlayerState.ZFPlayerStatePlaying
        } else {
            player.pause()
            isPauseByUser = true
            self.playState = ZFPlayerState.ZFPlayerStatePause
        }

    }
    //MARK:  slider事件
    // slider开始滑动事件
    func progressSliderTouchBegan(slider:UISlider) {
        isDragSlider = true;

        
    }
    // slider滑动中事件
    func progressSliderValueChanged(slider:UISlider) {
        let total   = CGFloat(playerItme.duration.value) / CGFloat(playerItme.duration.timescale);
        
        let current = NSInteger(total * CGFloat(slider.value));
        //秒数
        let proSec = NSInteger(current%60);
        //分钟
        let proMin = current/60;
        playMaskView.currentTimeLabel.text  = String(format: "%02d:%02d",proMin,proSec)
  
        
    }
    
    // slider结束滑动事件
    func progressSliderTouchEnded(slider:UISlider) {
        //计算出拖动的当前秒数
        let total           = CGFloat(self.playerItme.duration.value) / CGFloat(self.playerItme.duration.timescale)
        let drg = total * CGFloat(slider.value)
        let dragedSeconds = floorf(Float(drg))
        
        //转换成CMTime才能给player来控制播放进度
        
        let dragedCMTime     = CMTimeMake(Int64(dragedSeconds), 1);
        
        endSlideTheVideo(dragedCMTime: dragedCMTime)

        
    }
    
    func endSlideTheVideo(dragedCMTime:CMTime){
        player.pause()
        playMaskView.activity.startAnimating()
        
        player.seek(to: dragedCMTime, completionHandler: { (finish:Bool) in
            // 如果点击了暂停按钮
             self.playMaskView.activity.stopAnimating()
            if (self.isPauseByUser) {
                //NSLog(@"已暂停");
                self.isDragSlider = false;
                return ;
            }
            if ((self.playMaskView.progressView.progress - self.playMaskView.videoSlider.value) > 0.01) {
                self.playMaskView.activity.stopAnimating()
                self.player.play()
            }
            else
            {
                self.bufferingSomeSecond()
                
            }
            self.isDragSlider = false;
        })
     }
    func bufferingSomeSecond(){
        playMaskView.activity.startAnimating()
        // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
//        let isBuffering:Bool = false;
        if (isBuffering) {
            return;
        }
        isBuffering = true
        
        // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
        self.player.pause()
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 2.0) {
            // 如果此时用户已经暂停了，则不再需要开启播放了
            if (self.isPauseByUser) {
                self.isBuffering = false;
                return;
            }
            
            // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
            self.isBuffering = false;
            
            //播放缓冲区已满的时候 在播放否则继续缓冲
            //         [self.player play];
            
            
            /** 是否缓冲好的标准 （系统默认是1分钟。不建议用 ）*/
            //self.playerItme.isPlaybackLikelyToKeepUp
            
            if ((self.playMaskView.progressView.progress - self.playMaskView.videoSlider.value) > 0.01) {
                self.playState = ZFPlayerState.ZFPlayerStatePlaying
                self.player.play()
            }
            else
            {
                self.bufferingSomeSecond()
            }
            
        }

    }
    
    //MARK: 通知事件
    
    
    @objc private func moviePlayDidEnd(notification:NSNotification){
        SMLog(message: "播放完了")
          player.seek(to: CMTimeMake(0, 1), completionHandler: {[weak self] (finish:Bool) in
            
            
            self?.playMaskView.videoSlider.setValue(0, animated: true)
            self?.playMaskView.currentTimeLabel.text = "00:00"

        })
        
        self.playState = ZFPlayerState.ZFPlayerStateStopped
        self.playMaskView.startBtn.isSelected = false

    }
    
    func appDidEnterBackground(){
        player.pause()

    }
    
    func appDidEnterPlayGround(){
        if (self.playState == ZFPlayerState.ZFPlayerStatePlaying) {
            player.play()
        
     }
    }
    func listeningRotating(){
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    
    @objc private func onDeviceOrientationChange(){
        
        if UIInterfaceOrientation(rawValue: UIDevice.current.orientation.rawValue) == UIInterfaceOrientation.portrait  {
            frame = self.smallFrame
            
        }else if UIInterfaceOrientation(rawValue: UIDevice.current.orientation.rawValue) == UIInterfaceOrientation.landscapeRight{
            frame = self.bigFrame
        }
        
    }
    
    //设置播放进度和时间
    func setTheProgressOfPlayTime(){
        let interval = CMTime(seconds: 1.0,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // Queue on which to invoke the callback
        let mainQueue = DispatchQueue.main
        // Add time observer
        player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) {
                [weak self] time in
            //如果是拖拽slider中就不执行.
            
            guard self != nil else{
                return;
            }
            if (self?.isDragSlider)! {
                return ;
            }
            
            let current = CMTimeGetSeconds(time);
            let total = CMTimeGetSeconds(self!.playerItme.duration);
            
            if (current != 0) {
               // [weakSelf.maskView.videoSlider setValue:(current/total) animated:YES];
                
                self?.playMaskView.videoSlider.setValue(Float(current/total), animated: true)
            }
            
            //秒数
            let proSec = NSInteger(current)%60;
            //分钟
            let proMin = NSInteger(current)/60;
            
            guard total.toInt() != nil else {
                  return
            }
            let durSec = total.toInt()!%60;
            let durMin = total.toInt()!/60;

               //     = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
            self!.playMaskView.currentTimeLabel.text = String(format: "%02d:%02d",proMin,proSec)
            
            self!.playMaskView.totalTimeLabel.text   = String(format: "%02d:%02d", durMin, durSec)
        }
    }
    
 
    
    //MARK:  KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
         if (object as? AVPlayerItem == playerItme) {
            if (keyPath == "status") {
                
                if (player.status == AVPlayerStatus.readyToPlay) {
                    
                    playState = ZFPlayerState.ZFPlayerStatePlaying;
                    
                    
                } else if (player.status == AVPlayerStatus.failed){
                    playMaskView.activity.startAnimating()
                }
            } else if (keyPath == "loadedTimeRanges") {
                let timeInterval = availableDuration()// 计算缓冲进度
                let duration             = playerItme.duration;
                let totalDuration       = CMTimeGetSeconds(duration);
                
                //playMaskView.progressView.setProgress((timeInterval / Double(totalDuration),animated: false)
                playMaskView.progressView.setProgress(Float(timeInterval)/Float(totalDuration), animated: false)
                
                
            }else if (keyPath == "isPlaybackBufferEmpty") {
                
                //            NSLog(@"playbackBufferEmpty:%d",self.playerItme.playbackBufferEmpty);
                
                // 当缓冲是空的时候
                if (self.playerItme.isPlaybackBufferEmpty) {
                    self.playState = ZFPlayerState.ZFPlayerStateBuffering;
                    bufferingSomeSecond()
                }
                
            }else if (keyPath == "isPlaybackLikelyToKeepUp") {
                // 当缓冲好的时候
                SMLog(message: playerItme.isPlaybackLikelyToKeepUp);
                
                if (self.playerItme.isPlaybackLikelyToKeepUp){
                    SMLog(message: "isPlaybackLikelyToKeepUp");
                    self.playState = ZFPlayerState.ZFPlayerStatePlaying;
                }
            }
        }

    }
    
    
    func availableDuration() -> TimeInterval{
    //NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    let loadedTimeRanges = player.currentItem?.loadedTimeRanges
    let timeRange = loadedTimeRanges?.first?.timeRangeValue// 获取缓冲区域
    let startSeconds        = CMTimeGetSeconds((timeRange?.start)!);
    let durationSeconds     = CMTimeGetSeconds((timeRange?.duration)!);
    let result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
    }
    
    //MARK: Volume 系统音量
    

    func getVolumeVolue(){
        let volumeView = MPVolumeView()
        
        volumeViewSlider = nil;
        for view in volumeView.subviews {
            
               if (NSStringFromClass(view.classForCoder) == "MPVolumeSlider"){
                volumeViewSlider = view as? UISlider
                
                self.addSubview(volumeViewSlider!);
                break;
            }
        }
//        volumeViewSlider?.value = 0.001
        volumeViewSlider?.frame = CGRect(x: -1000, y: -1000, width: 100, height: 100);
        
        
        /* 马上获取不到值 */
        perform(#selector(afterOneSecond), with: nil, afterDelay: 2)
    }
    
    
    func afterOneSecond(){
        playMaskView.volumeProgress.progress = (volumeViewSlider?.value)!;

    }
    func panDirection(pan:UIPanGestureRecognizer){
        let veloctyPoint = pan.velocity(in: self)
        
        switch pan.state {
        case UIGestureRecognizerState.began:
            let x = fabsf(Float(veloctyPoint.x))
            let y = fabsf(Float(veloctyPoint.y))
            if x > y {// 水平移动
                panDirection = PanDirection.PanDirectionHorizontalMoved
                self.isDragSlider = true
            }else{
                panDirection = PanDirection.PanDirectionVerticalMoved
            }
            break
        case UIGestureRecognizerState.changed:
            switch panDirection! {
            case PanDirection.PanDirectionHorizontalMoved:
                horizontalMoved(value: veloctyPoint.x)
                progressSliderValueChanged(slider: playMaskView.videoSlider)
                break
            case PanDirection.PanDirectionVerticalMoved:
                verticalMoved(value: veloctyPoint.y)
                break
             }
            
        case UIGestureRecognizerState.ended:
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug

            switch panDirection! {
            case PanDirection.PanDirectionHorizontalMoved:
                 progressSliderTouchEnded(slider: playMaskView.videoSlider)
                 break
            case PanDirection.PanDirectionVerticalMoved:
                // 垂直移动结束后，把状态改为不再控制音量
                break
            }

        default:
            break
        }
        
        
    }
    
    func verticalMoved(value:CGFloat){
    // 更改系统的音量
    volumeViewSlider?.value      = (volumeViewSlider?.value)! - Float(value / 10000)// 越小幅度越小
    
    }
    
    func horizontalMoved(value:CGFloat){
    playMaskView.videoSlider.value = playMaskView.videoSlider.value + Float(value/10000);
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        UIApplication.shared.isStatusBarHidden = false
        playerLayer.frame = bounds
        playMaskView.frame = bounds
    }
    
    deinit {
        playerItme.removeObserver(self, forKeyPath: "status")
        playerItme.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItme.removeObserver(self, forKeyPath: "isPlaybackLikelyToKeepUp")
        playerItme.removeObserver(self, forKeyPath: "isPlaybackBufferEmpty")
        NotificationCenter.default.removeObserver(self)
        player.pause()

    }
    
    
    
 
}

extension Double {
    func toInt() -> Int?{
        if self > Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}








