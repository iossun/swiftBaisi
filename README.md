### swift百思简单介绍
       对培训班OC百思不得姐，swift编写。
      主要做OC开发，为进一步提升自己，花了一点休息时间，学习了下swift开发App。这个swift的项目是我第一个swift项目，接口数据来源百思服务器的公开接口（后面添加了电影，准备用豆瓣的电影接口），项目的界面设置和UI图片现成别人工程里导出来的

#### 目前的app简介
* 登陆界面与注册界面
  1. 界面由xib搭建，登陆与注册间跳转（对xib中约束添加动画）
  2. 快速登陆按钮（自定义button管理）
* 我的界面，精华（app主要内容的呈现）
  1. 界面加载数据处理（swift没找到类似MJExtension库，简单的用runtime对对想要数据获取）
  		
  		    for i in 0..<count {
            //取出属性名
            let ivar = ivars?[Int(i)]
            let ivarName = ivar_getName(ivar!)
            let nName = String(cString: ivarName!)
            if "top_cmt" == nName{//最热评论
                if dict[nName] != nil {//有数据
                     let array:[[String:AnyObject]] = dict[nName] as! [[String : AnyObject]]
                    if array.count > 0 {//数据不为空
                        let cmt =  comments(dict: array[0])
                        self.setValue(cmt, forKey: nName)
                    }
                }
            }else{
                if dict[nName] != nil {//数据不为空
                    self.setValue(dict[nName], forKey: nName)
              }
            }
         }
  2. 下拉刷新，上拉加载（简单使用写了一个继承UIRefreshControl，拉动到一个位置自动加载待优化，理想手释放的时候释放，有时间再改）
  3. 自定义了一个视频播放器，基于AVplay的封装（支持横屏，暂停，播放，音量，控制）       
* 自定义扫码<br />
  	原生图片采集分析实现扫码功能，显示简单做了一个动画 （二维码能成扫描出来，扫描出路径暂无做跳转）
  
#### 使用三方库介绍
* Alamofire (类似AFN，作者为同一人！异步加载，完成回调，一个函数用起来很爽没必要自己写，性能检查时没请求一次网路数据有4k的内存泄漏，几乎可以忽略，待作者维护吧，没有时间深究这个问题)
* SDWebImage（和OC里一样，通过桥接过来，很稳定，有人不断维护）
* SnapKit （纯代码是链式添加约束）
* SVprogressHUD （提示框）    	     
