//
//  SMTopicViewController.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/25.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit
import SVProgressHUD

class TopicViewController: UITableViewController {

    var topics:[topic]? = [topic]()
    var maxtime:String?
    
    //是否可以再一起加载
    var canLoadMore:Bool = true
    //给子类接口
    open func type() ->(Int){
        return 0;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        //let refreshi = UIRefreshControl()
        refreshControl = RefreshControl.init()
         refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        loadData()
        refreshControl?.beginRefreshing()

   
        
     }
    private func setupTable() {
      //  tableView.backgroundColor = UIColor(colorLiteralRed: 205/255, green: 206/255, blue: 205/255, alpha: 1)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.contentInset = UIEdgeInsets(top: 64 + 35, left: 0, bottom: 49, right: 0)
        tableView.rowHeight = 250;
         tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.register(UINib(nibName: "topicCell", bundle: nil)
            , forCellReuseIdentifier: "topic")
        
      }
    
    @objc private func loadData(){
        
        //__weak var weakSelf = self;
        NetworkTools.shareInstance.loadEssenceTopic(finished:{[weak self](dict,error) ->Void in
            if let _ = error{
                SVProgressHUD.showError(withStatus: "获取主题列表失败")
            }
            guard let res = dict else{
                SVProgressHUD.showError(withStatus: "服务器返回数据为空")
                return
            }
            if (self?.topics) != nil{
                self?.topics?.removeAll()

            }
             self?.maxtime = res["info"]?["maxtime"] as? String;
            let array:[[String:AnyObject]] = res["list"] as! [[String : AnyObject]]
            
            for  dic in array{
                let meSquare = topic.init(dict: dic)
                self?.topics?.append(meSquare)
            }
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }, type:type())
    }
    
    
    func loadMoreTopics() {
        NetworkTools.shareInstance.loadMoreEssenceTopic(finished: {[weak self](dict,error) ->Void in
            if let _ = error{
                SVProgressHUD.showError(withStatus: "获取主题列表失败")
            }
            guard let res = dict else{
                SVProgressHUD.showError(withStatus: "服务器返回数据为空")
                return
            }
            //完成加载，允许下一次加载
            self?.canLoadMore = true

            self?.maxtime = res["info"]?["maxtime"] as? String;
            let array:[[String:AnyObject]] = res["list"] as! [[String : AnyObject]]
            
            for  dic in array{
                let meSquare = topic.init(dict: dic)
                self?.topics?.append(meSquare)
            }
            self?.tableView.reloadData()
            }, type: type(), maxtime: maxtime!)
    }
    
    
    //MARK -----  tableView数据源方法
    // 创建分区
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 每个分区的行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (topics?.count)!
        
    }
 //    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 15
//    }
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    
    
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "topic") as! topicCell
        cell.topic = topics?[indexPath.row]
        return cell
        
    }
    
    // cell的选中事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return topics![indexPath.row].cellHeight()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if  scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height + 70 ) && scrollView.contentSize.height != 0 && canLoadMore {
            canLoadMore = false
            loadMoreTopics()
        }
    }
    
}
