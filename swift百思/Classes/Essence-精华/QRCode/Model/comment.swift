//
//  comment.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/12/1.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

class comments: NSObject {
    var ID:String?
    var content:String?
    var user:users?
    var like_count:Int = 0
    var voicetime:Int = 0
    var voiceuri:String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        //        setValuesForKeys(dict)
        //Runtime获取本类属性
        var count:UInt32 = 0
        let ivars = class_copyIvarList(self.classForCoder, &count)
        for i in 0..<count {
            //取出属性名
            let ivar = ivars?[Int(i)]
            let ivarName = ivar_getName(ivar!)
            let nName = String(cString: ivarName!)
            if "user" == nName{
                if dict[nName] != nil {
                    let dic:[String:AnyObject] = dict[nName] as! [String : AnyObject]
                    let cmt =  users(dict: dic)
                    self.setValue(cmt, forKey: nName)
                }

            }else{
                if dict[nName] != nil {
                    self.setValue(dict[nName], forKey: nName)
                    
                }

            }
           }
        
    }

    
}
