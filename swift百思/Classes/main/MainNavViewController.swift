//
//  SMNavViewController.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/21.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

class MainNavViewController: UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        interactivePopGestureRecognizer?.delegate = self
        
        navigationBar.setBackgroundImage(UIImage(named:"navigationbarBackgroundWhite"), for: UIBarMetrics.default)
        
        // Do any additional setup after loading the view.
    }
    /**
     *  重写push方法的目的 : 拦截所有push进来的子控制器
     *
     *  @param viewController 刚刚push进来的子控制器
     */
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count > 0 {// 如果viewController不是最早push进来的子控制器
            //左上角
            let button = UIButton(type: UIButtonType.custom)
            button.setImage(UIImage(named:"navigationButtonReturn"), for: UIControlState.normal)
            button.setImage(UIImage(named:"navigationButtonReturnClick"), for: UIControlState.highlighted)
            button.setTitle("返回", for: UIControlState.normal)
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.setTitleColor(UIColor.red, for: UIControlState.highlighted)
            button.sizeToFit()
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
            button.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
            
            //统一隐藏工具条
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func back(){
        popViewController(animated: true)
    }
    
    //MARK: - <UIGestureRecognizerDelegate>
    /**
     *  手势识别器对象会调用这个代理方法来决定手势是否有效
     *
     *  @return YES : 手势有效, NO : 手势无效
     */
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return childViewControllers.count > 1
    }
    
     
  }
