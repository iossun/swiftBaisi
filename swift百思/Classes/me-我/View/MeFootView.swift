//
//  SMMeFootView.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/28.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class MeFootView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
       //加初始化的数据
        NetworkTools.shareInstance.loadSquareTopic(finished: {(dict,error) ->Void in
            if let _ = error{
                SVProgressHUD.showError(withStatus: "获取主题列表失败")
            }
            guard let res = dict else{
                SVProgressHUD.showError(withStatus: "服务器返回数据为空")
                return
            }
            
            let array:[[String:AnyObject]] = res["square_list"] as! [[String : AnyObject]]
            var modelArray:[MeSquare]? = [MeSquare]()

            for  dic in array{
                let meSquare = MeSquare.init(dict:dic)
                 modelArray?.append(meSquare)
             }
            self.createSquares(square: modelArray!)

           })
      }
    
    /// createSquares
    ///
    /// - Parameter square: 模型数据
    private func createSquares(square:[MeSquare]){
        
        let count = square.count
        let maxColsCount = 4
        let buttonW = Int(frame.size.width) / maxColsCount
        let buttonH = buttonW
        
        for i in 0..<count {
            let button = MeSquareButton(frame: CGRect(x: (i % maxColsCount) * buttonW, y: (i / maxColsCount) * buttonH, width: buttonW, height: buttonH))
           
            button.square = square[i]
            button.addTarget(self, action:#selector(buttonClick(btn:)), for: UIControlEvents.touchUpInside)
            addSubview(button)
        }
    
        frame.size.height = (subviews.last?.frame.maxY)!
        let tableView = superview as! UITableView
        tableView.reloadData()
        
    }
    
    
    //MARK：主题方块点击按钮
    @objc private func buttonClick(btn:MeSquareButton){
        let url = btn.square?.url
        if (url?.hasPrefix("http"))! {
            let tableBarVC = window?.rootViewController as! UITabBarController
            let currentVc = tableBarVC.selectedViewController as! UINavigationController
            //webView加载视图，然后跳转
            let webViewVC = webViewController()
            webViewVC.navigationItem.title = btn.currentTitle
            webViewVC.url = url
            currentVc.pushViewController(webViewVC, animated: true)
            
        }else if (url?.hasPrefix("mod"))!{
            if (url?.hasSuffix("BDJ_To_Check"))!{
                //跳转到审帖界面
                SVProgressHUD.show(withStatus: "待开发审帖")
            }else if (url?.hasSuffix("BDJ_To_RecentHot"))!{
                //跳转到[每日排行]界面
                SVProgressHUD.show(withStatus: "待开发每日排行")
            }else{
                //跳转到其他界面
                SVProgressHUD.show(withStatus: "跳转到其他界面")
    
            }
            
            
        }else{
            //不是http或mod协议
            SVProgressHUD.show(withStatus: "不是http或mod协议")
         }
         // 用异步的方式运行队列里的任务
        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.async {
                SVProgressHUD.dismiss(withDelay: 2)
            }
        }
        
    }
   
 
}
