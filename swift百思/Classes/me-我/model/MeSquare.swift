//
//  MeSquare.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/29.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

class MeSquare: NSObject {

    
    /** 名字 */
    var name: String?;
    /** 图标 */
    var icon: String?;
    /** 路径 */
    var url: String?;
    
    
    init(dict: [String :AnyObject]) {
        super.init()
        //Runtime获取本类属性
        var count:UInt32 = 0
        let ivars = class_copyIvarList(self.classForCoder, &count)
        for i in 0..<count {
            //取出属性名
            let ivar = ivars?[Int(i)]
            let ivarName = ivar_getName(ivar!)
            let nName = String(cString: ivarName!)
            self.setValue(dict[nName], forKey: nName)
        }
        
    }
}
