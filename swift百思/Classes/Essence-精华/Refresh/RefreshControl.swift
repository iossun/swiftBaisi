//
//  RefreshControl.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/12/08.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

import UIKit
import SnapKit

class RefreshControl: UIRefreshControl {

    
    override init() {
        
        super.init()
        
        // 1.添加子控件
        addSubview(refreshView)
        // 2.布局子控件
        refreshView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 150, height: 60))
        }
        // 3.注册监听, 监听frame的改变
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        removeObserver(self, forKeyPath: "frame")
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.endAnimation()
    }
    

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 下拉刷新控件的frame一旦改变就会调用
        
        /*
         规律: 越往下拉Y越小, 越往上推Y越大
         */
        // 1.过滤垃圾数据
        if frame.origin.y == 0 || frame.origin.y == -64
        {
            return
        }
        
            // 2.检查是否已经触发下拉刷新
        if isRefreshing
        {
            
            refreshView.startAnimation()
            return
        }
 
        // 3.控制箭头旋转
        if frame.origin.y < -50 && !refreshView.showRotationFlag
        {
            refreshView.showRotationFlag = true
            refreshView.rotationArrow()
        }else if frame.origin.y > -50 && refreshView.showRotationFlag
        {
            refreshView.showRotationFlag  = false
            refreshView.rotationArrow()
        }

    }
    

    
    // MARK: - 懒加载
    private lazy var refreshView = RefreshView.refreshView()
}

class RefreshView: UIView {
    
    /// 提示视图
    @IBOutlet weak var tipsView: UIView!
    /// 箭头视图
    @IBOutlet weak var arrowImageView: UIImageView!
    /// 菊花视图
    @IBOutlet weak var loadingImageVIew: UIImageView!
    
    // 记录是否需要旋转
    var showRotationFlag = false
    
    /// 快速创建提示视图
    class func refreshView() -> RefreshView  {
        return Bundle.main.loadNibNamed("RefreshView", owner: nil, options: nil)!.last as! RefreshView
    }
    
     func rotationArrow()
    {
        /*
        规律: 1.默认是顺时针 2.就近原则
        */
        var angle = CGFloat(M_PI)
        angle = showRotationFlag ? angle - 0.01 : angle + 0.01
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: angle)
        }
    }
    // MARK: - 内部控制方法
    /// 开始菊花旋转动画
     func startAnimation()
    {
        // 0.隐藏提示视图
        tipsView.isHidden = true
        
        let key = "transform.rotation"
        if let _  = loadingImageVIew.layer.animation(forKey: key)
        {
            return
        }
        
        // 1.创建动画对象
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        // 2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 10.0
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false

        // 3.将动画添加到图层
        loadingImageVIew.layer.add(anim, forKey: key)
    }
    
    /// 停止菊花旋转动画
     func endAnimation()
    {
        // 0.显示提示视图
        tipsView.isHidden = false
        
        // 1.移除动画
        loadingImageVIew.layer.removeAllAnimations()
    }
}
