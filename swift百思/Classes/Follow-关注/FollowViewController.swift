//
//  SMFollowViewController.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/18.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

class FollowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        //导航条item添加图片点击事件（扩展）
        navigationItem.leftBarButtonItem = UIBarButtonItem(target: self,imageName: "friendsRecommentIcon", highImage: "friendsRecommentIcon-click", action: #selector(FollowViewController.followClick), for: UIControlEvents.touchUpInside)

     }
    
    
 //MARK: view添加的方法
    
   @objc private func followClick()  {
        let pushVC = MooViewController()
       // pushVC.view.backgroundColor = UIColor.red;
        navigationController?.pushViewController(pushVC, animated: true)
    }

 //MARK: 连线方法
 //点击立刻登陆
    @IBAction func loginRegister(_ sender: UIButton) {
        present(LoginRegisterViewController(), animated: true, completion: nil)
    
//        SMLoginRegisterViewController()
//        SMLog(message: 111);
    }
    
    deinit {
        
    }
    
  
}
