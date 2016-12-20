//
//  SMLoginRegisterViewController.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/22.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController {


    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
    }
    
    //MARK:连线事件
    /**
     *  关闭当前界面
     */
    @IBAction func close(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    /**
     *  显示登录\注册界面
     */
    
    @IBAction func showLoginOrRegister(_ sender: UIButton) {
        //退出键盘
        view.endEditing(true)
        if 0 != leftMargin.constant {
            leftMargin.constant = 0
            sender.isSelected = false
        }else{
            leftMargin.constant = -view.frame.size.width;
            sender.isSelected = true;
        }
        
        UIView.animate(withDuration: 0.25, animations:{() -> Void in
            self.view.layoutIfNeeded()
        })
      }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    deinit {
        print("销毁了")
    }
}
