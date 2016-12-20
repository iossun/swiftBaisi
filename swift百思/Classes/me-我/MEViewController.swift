//
//  SMMEViewController.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/21.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class MEViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    var tableView:UITableView!

     override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNav()
         
    }
    
    func setupTableView() {
        tableView = UITableView.init(frame: self.view.frame, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view .addSubview(tableView)
        
        // 注册cell
        // tableView .register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = MeFootView(frame:view.frame)
    }
    
    func setupNav() {
        navigationItem.title = "我的"
        let settingItem = UIBarButtonItem(target: self, imageName: "mine-setting-icon", highImage: "mine-setting-icon-click", action: #selector(settingClick), for: UIControlEvents.touchUpInside)
        
        let moomItem = UIBarButtonItem(target: self, imageName: "mine-moon-icon", highImage: "mine-moon-icon-click", action: #selector(moonClick), for: UIControlEvents.touchUpInside)
        
        navigationItem.rightBarButtonItems = [settingItem,moomItem]
    }
    
    
    @objc private func settingClick(){
        
    }
    @objc private func moonClick(){
        
    }
    
    
    //MARK -----  tableView数据源方法
    // 创建分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 每个分区的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // 分区头部显示
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return addHeaders[section]
//    }
    
    // 分区尾部显示
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        let data = allNames[section]
//        return "有\(data!.count)个控件"
//    }
    
    // 显示cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify = "cell"
        
      //  let secno =
       // var cell = UITableViewCell()
        var cell = tableView.dequeueReusableCell(withIdentifier: identify)
        if cell == nil {
            cell = MeTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier:identify)
        }
        
        if indexPath.section == 0 {
            
            cell?.textLabel?.text = "登录/注册"
            cell?.imageView?.image = UIImage(named:"publish-audio")
            }
            else
            {
                cell?.textLabel?.text = "离线下载"
            }
    
        return cell!
        
    }
    
    // cell的选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath[0] == 0 && indexPath[0] == 0 {
            present(LoginRegisterViewController(), animated: true, completion: nil)
        }
    }


}
