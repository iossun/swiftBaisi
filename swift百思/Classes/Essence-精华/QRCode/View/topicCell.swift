//
//  topicCell.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/12/1.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit
import SDWebImage

class topicCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var text_label: UILabel!
    @IBOutlet weak var dingButton: UIButton!
    @IBOutlet weak var caiButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var topCmtView: UIView!
    @IBOutlet weak var topCmtContentLabel: UILabel!
 
  
    var topic:topic?{
        didSet{
           
            profileImageView.image = UIImage.circleImage(named: "defaultUserIcon")
            profileImageView.sd_setImage(with:  NSURL(string: (topic?.profile_image)!) as URL?, completed: {
                (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                self.profileImageView.image = image?.circleImage()
            })
            
            nameLabel.text = topic?.name
            createdAtLabel.text = topic?.created_at
            self.text_label.text = topic?.text
          
            setupBtn(button: dingButton, number: (topic?.ding)!, placehold: "顶")
            setupBtn(button: caiButton, number: (topic?.cai)!, placehold: "踩")
            setupBtn(button: repostButton, number: (topic?.repost)!, placehold: "分享")
            setupBtn(button: commentButton, number: (topic?.comment)!, placehold: "评论")
          
            // 最热评论
            if ((topic?.top_cmt) != nil) { // 有最热评论
                self.topCmtView.isHidden = false

                guard let userName = topic?.top_cmt?.user?.username else{
                    return
                }
                guard var content = topic?.top_cmt?.content else {
                    return
                }
                if (topic?.top_cmt?.voiceuri) != ""{
                    SMLog(message: topic?.top_cmt?.voiceuri)
                    content = "[语音评论]"
                }

                topCmtContentLabel.text = userName + ":" + content
                
            
              }else{
                topCmtView.isHidden = true
  
              }
            
            // 中间内容
            
            if topic?.type == topicType.TopicTypeVideo.rawValue {//视频
                VideoView.frame = (topic?.contentF)!
                VideoView.topic = topic
                VideoView.isHidden = false
                VoiceView.isHidden = true
                pictureView.isHidden = true

                
            }else if topic?.type == topicType.TopicTypeVoice.rawValue{//音频
                VoiceView.frame = (topic?.contentF)!
                VoiceView.topic = topic
                VideoView.isHidden = true
                VoiceView.isHidden = false
                pictureView.isHidden = true

                
            }else if topic?.type == topicType.TopicTypeWord.rawValue{//段子
                VideoView.isHidden = true
                VoiceView.isHidden = true
                pictureView.isHidden = true
                
            }else if topic?.type == topicType.TopicTypePicture.rawValue{//图片
                pictureView.isHidden = false

                pictureView.frame = (topic?.contentF)!
                pictureView.topic = topic
                VideoView.isHidden = true
                VoiceView.isHidden = true
 
            }

            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundView = UIImageView(image: UIImage(named: "mainCellBackground"))

    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MArk:点击cell的更多
    @IBAction func more(_ sender: Any) {
    }
    
    /**
     *  设置按钮的数字 (placeholder是一个中文参数, 故意留到最后, 前面的参数就可以使用点语法等智能提示)
     */
    
    private func setupBtn(button:UIButton,number:Int,placehold:String){
        if number >= 10000 {
            button.setTitle((String(format: "%.1f万",Float(number)/10000.0)), for: UIControlState.normal)
        }else if (number > 0){
            button.setTitle((String(format: "%ld",number)), for: UIControlState.normal)

        }else{
            button.setTitle(placehold, for: UIControlState.normal)

        }
    }
    
    
    
    //图片
    // MARK: - 懒加载
    private lazy var pictureView:TopicPictureView = {
        let picture = Bundle.main.loadNibNamed("TopicPictureView", owner: nil, options: nil)?.last as! TopicPictureView
        self.contentView.addSubview(picture)

        return picture
    }()
    private lazy var VideoView:TopicVideoView = {
        let VideoView = Bundle.main.loadNibNamed("TopicVideoView", owner: nil, options: nil)?.last as! TopicVideoView
        self.contentView.addSubview(VideoView)
        
        return VideoView
    }()
    private lazy var VoiceView:TopicVoiceView = {
        let VoiceView = Bundle.main.loadNibNamed("TopicVoiceView", owner: nil, options: nil)?.last as! TopicVoiceView
        self.contentView.addSubview(VoiceView)
        
        return VoiceView
    }()
    
}
