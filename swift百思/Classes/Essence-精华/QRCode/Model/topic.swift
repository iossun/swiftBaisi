//
//  topic.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/12/1.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

public enum topicType : Int {
    /** 全部 */
    /** 图片 */
    /** 段子 */
    /** 声音 */
    /** 视频 */
    case TopicTypeAll = 1,TopicTypePicture = 10,TopicTypeWord = 29,TopicTypeVoice = 31,TopicTypeVideo = 41
}

class topic: NSObject {
    /** id */
    var  id: String?
    /** 用户的名字 */
    var  name: String?
    /** 用户的头像 */
    var  profile_image: String?
    /** 帖子的文字内容 */
    var  text: String?
    /** 帖子审核通过的时间 */
    var  created_at: String?
    /** 顶数量 */
    var  ding: Int = 0
    /** 踩数量 */
    var  cai: Int = 0
    /** 转发\分享数量 */
    var  repost: Int = 0
    /** 评论数量 */
    var  comment: Int = 0
    /** 最热评论 */
    var  top_cmt: comments?
    /** 帖子类型 */
    var type: Int = 0
    /** 图片的真实宽度 */
    var  width: Float = 0.0
    /** 图片的真实高度 */
    var  height: Float = 0.0
    /** 小图 */
    var  image0: String?
    /** 中图 */
    var  image1: String?
    /** 大图 */
    var  image2: String?
    /** 音频时长 */
    var  voicetime: Int = 0
    /** 视频时长 */
    var  videotime: Int = 0
    /** 音频\视频的播放次数 */
    var  playcount: Int = 0
    /** 是否为gif动画图片 */
     var  is_gif: Int = 0
    /** 中间内容的frame */
    var  contentF: CGRect?
    /** 是否为超长图片 */
    var  bigPicture: Int = 0
  
    
    init(dict: [String: AnyObject]) {
          super.init()
        //Runtime获取本类属性
        var count:UInt32 = 0
        let ivars = class_copyIvarList(self.classForCoder, &count)
        for i in 0..<count {
            //取出属性名
            let ivar = ivars?[Int(i)]
            let ivarName = ivar_getName(ivar!)
            let nName = String(cString: ivarName!)
            if "top_cmt" == nName{
                if dict[nName] != nil {
                     let array:[[String:AnyObject]] = dict[nName] as! [[String : AnyObject]]
                    if array.count > 0 {
                        let cmt =  comments(dict: array[0])
                        self.setValue(cmt, forKey: nName)
                    }
                }
            }else{
                if dict[nName] != nil {
                    self.setValue(dict[nName], forKey: nName)
              }
            }
         }
     }
    
 
    //计算cell的高度
    
     func cellHeight() -> CGFloat {
        //1.头像
        var cellHeight:CGFloat = 55
        
        //2.文字
        let textMaxW = UIScreen.main.bounds.size.width - 20 //Margin = 10
        
        let textMaxSize = CGSize(width: textMaxW, height: CGFloat(MAXFLOAT))
        
        let textSize = text?.boundingRect(with: textMaxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)], context: nil)
        cellHeight += (textSize?.height)! + 10 //Margin
        //3.中间的内容
        if type != topicType.TopicTypeWord.rawValue {//如果是图片\声音\视频帖子，才需要计算中间内容的高度
        // 中间内容的高度 == 中间内容的宽度 * 图片的真实高度 / 图片的真实宽度
        var contentH = textMaxW * (CGFloat(height) / CGFloat(width))
        if contentH > UIScreen.main.bounds.size.height {//超长图片 ————.>写成200
             contentH = 200
             bigPicture = 1
        }
        // 这里的cellHeight就是中间内容的y值
        self.contentF = CGRect(x: CGFloat(10), y: CGFloat(cellHeight), width: textMaxW, height: contentH)
        
        // 累加中间内容的Y值
        cellHeight += contentH + 10
        
        }
        
        // 4. 最热评论
        if self.top_cmt != nil {
        //标题
        cellHeight += 20
        //最热评论-内容
        var content = self.top_cmt?.content
        if self.top_cmt != nil { // 有最热评论
        
        if (self.top_cmt?.voiceuri) != nil{
        content = "[语音评论]"
        }
        guard let userName = self.top_cmt?.user?.username else{
        return cellHeight + 35//工具条
        }
        
        let str = userName + ":" + content!
        
        let topCmtContentSize = str.boundingRect(with: textMaxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)], context: nil)
        cellHeight += topCmtContentSize.height + 10
        }
        }
        
        return cellHeight + 35 + 10
     }
    
    
    
}
