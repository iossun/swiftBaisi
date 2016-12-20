//
//  NetworkTools.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/28.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit
import Alamofire
class NetworkTools: NSObject {
    static let shareInstance:NetworkTools = {
        let instance = NetworkTools()
        return instance
    }()
    
    
     /// 加载主题方块
     ///
     /// - Parameter finished: 加载完成或失败block出去
     func loadSquareTopic(finished:@escaping (_ dicts:[String: AnyObject]?,_ error: NSError?) ->()) {
        let paream = ["a":"square","c":"topic"]

         Alamofire.request("http://api.budejie.com/api/api_open.php", method: .get, parameters: paream).responseJSON{
            (response) in
             switch response.result {
            case .success( _):
                //当响应成功是，使用临时变量value接受服务器返回的信息并判断是否为[String: AnyObject]类型 如果是那么将其传给其定义方法中的success
                //                    if let value = response.result.value as? [String: AnyObject] {
                if let value = response.result.value as? [String: AnyObject] {
                     finished(value as [String : AnyObject]?, nil)
                }
             
            case .failure(let error):
                finished(nil, error as NSError?)
            }
            
        }

    }
    /// 加载帖子
    ///
    /// - Parameter finished: 加载完成或失败block出去
    func loadEssenceTopic(finished:@escaping (_ dicts:[String: AnyObject]?,_ error: NSError?) ->(), type:Int) {
        let paream = ["a":"list","c":"data","type":type] as [String : Any]
        
        Alamofire.request("http://api.budejie.com/api/api_open.php", method: .get, parameters: paream).responseJSON{
            (response) in
            switch response.result {
            case .success( _):
                //当响应成功是，使用临时变量value接受服务器返回的信息并判断是否为[String: AnyObject]类型 如果是那么将其传给其定义方法中的success
      
                if let value = response.result.value as? [String: AnyObject] {
                    finished(value as [String : AnyObject]?, nil)
                }
                
            case .failure(let error):
                finished(nil, error as NSError?)
            }
            
        }
        
    }
    /// 加载更多帖子
    ///
    /// - Parameter finished: 加载完成或失败block出去
    func loadMoreEssenceTopic(finished:@escaping (_ dicts:[String: AnyObject]?,_ error: NSError?) ->(), type:Int ,maxtime:String) {
        let paream = ["a":"list","c":"data","maxtime":maxtime,"type":type] as [String : Any]
        
        Alamofire.request("http://api.budejie.com/api/api_open.php", method: .get, parameters: paream).responseJSON{
            (response) in
            switch response.result {
            case .success( _):
                //当响应成功是，使用临时变量value接受服务器返回的信息并判断是否为[String: AnyObject]类型 如果是那么将其传给其定义方法中的success
                
                if let value = response.result.value as? [String: AnyObject] {
                    finished(value as [String : AnyObject]?, nil)
                }
                
            case .failure(let error):
                finished(nil, error as NSError?)
            }
            
        }
        
    }

  
    
}
