//
//  SMMainViewController.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/21.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

class SMMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //创建子控制器
        tabBar.tintColor = UIColor.gray;
        let dic = [NSForegroundColorAttributeName:UIColor.black];
        UITabBarItem.appearance().setTitleTextAttributes(dic, for: UIControlState.selected)
      //
        
        addChildViewControllers()
     }
    
    func addChildViewControllers() {
        
        addChildViewControllers(viewControl: EssenceViewController(), title: "精华", image: "tabBar_essence_icon", selectedImage: "tabBar_essence_click_icon")
        
        addChildViewControllers(viewControl: MovieViewController(), title: "电影", image: "tabBar_new_icon", selectedImage: "tabBar_new_click_icon")
        addChildViewControllers(viewControl: FollowViewController(), title: "关注", image: "tabBar_friendTrends_icon", selectedImage: "tabBar_friendTrends_click_icon")
        addChildViewControllers(viewControl: MEViewController(), title: "我", image: "tabBar_me_icon", selectedImage: "tabBar_me_click_icon")

    }
    
    func addChildViewControllers(viewControl:UIViewController, title: String,image: String,selectedImage:String){
        
        viewControl.title = title;
           //设置属性
        viewControl.tabBarItem.title = title
        viewControl.tabBarItem.image = UIImage(named:image)
        viewControl.tabBarItem.selectedImage = UIImage(named: selectedImage)
        
        let navVC = MainNavViewController(rootViewController: viewControl)
        
        addChildViewController(navVC);
     }

}
