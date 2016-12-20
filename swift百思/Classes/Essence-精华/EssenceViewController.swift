//
//  SMEssenceViewController.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/18.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

class EssenceViewController: UIViewController,UIScrollViewDelegate {
    /** 当前选中的标题按钮 */
    var selectedTitleButton:UIButton?
    /** 标题按钮底部的指示器 */
    var indicatorView:UIView?
    /** UIScrollView */
    var scrollView:UIScrollView?
    /** 标题栏 */
    var titleView:UIView!

     override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupChildViewControllers()
        setupScrollView()
        setupTitlesView()
        //添加默认的子控制器
        addChildVcView()
        for _ in 0...100{
           setupChildViewControllers()  
        }
     }
    
    private func setupNav() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "MainTitle"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(target: self, imageName: "MainTagSubIcon", highImage: "MainTagSubIconClick", action: #selector(EssenceViewController.leftNarTitleClick), for: UIControlEvents.touchUpInside)
        
          navigationItem.rightBarButtonItem = UIBarButtonItem(target: self, imageName: "navigationbar_pop", highImage: "navigationbar_pop_highlighted", action: #selector(EssenceViewController.rightNarTitleClick), for: UIControlEvents.touchUpInside)
    }
    
    @objc private func leftNarTitleClick(){
        SMLog(message: "haoya")
    }
    
    @objc private func rightNarTitleClick(){
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        
        let QRCoderVc = sb.instantiateInitialViewController()!
        
   //     navigationController?.pushViewController(QRCoderVc, animated: true)
        present(QRCoderVc, animated: true, completion: nil)
      }

    private func setupChildViewControllers(){
        addChildViewController(VoiceViewController())
        addChildViewController(AllViewController())
        addChildViewController(VideoViewController())
        addChildViewController(PictureViewController())
        addChildViewController(WordViewController())
    }
    
    private func setupScrollView(){
        // 不允许自动调整scrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        scrollView = UIScrollView()
       // scrollView?.backgroundColor = UIColor.gray
        scrollView?.frame = view.bounds
        scrollView?.isPagingEnabled = true
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.delegate = self
        scrollView?.contentSize = CGSize(width: childViewControllers.count * Int((scrollView?.frame.size.width)!), height: 0)
        view.addSubview(scrollView!)
    }
    
    
    private func setupTitlesView(){
        titleView = UIView()
        titleView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
      
        titleView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: 35)
        view.addSubview(titleView)
        
        let titles = ["声音","全部","视频","图片","段子"]
        let count = titles.count
        let buttonW = Int(view.frame.size.width) / count
        let buttonH = titleView.frame.size.height
        
        for  i in 0..<count {
            let titleBtn = UIButton(type: UIButtonType.custom)
            titleBtn.tag = i
            titleBtn.frame = CGRect(x: i * buttonW, y: 0, width: buttonW, height: Int(buttonH))
            titleBtn.setTitle(titles[i], for: UIControlState.normal)
            titleView.addSubview(titleBtn)
            titleBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            titleBtn.setTitleColor(UIColor.red, for: UIControlState.selected)
            titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)

            titleBtn.addTarget(self, action: #selector(titleClick(btn:)), for: UIControlEvents.touchUpInside)
            
        }
        let firstBtn = titleView.subviews.first as! UIButton
        
        indicatorView = UIView()
        indicatorView?.backgroundColor = UIColor.red
        indicatorView?.frame.size.height = 1
        indicatorView?.frame.origin.y = titleView.frame.size.height - (indicatorView?.frame.size.height)!
        titleView.addSubview(indicatorView!)
        
        // 立刻根据文字内容计算label的宽度
        firstBtn.titleLabel?.sizeToFit()
        indicatorView?.frame.size.width = (firstBtn.titleLabel?.frame.width)!
         indicatorView?.center.x = firstBtn.center.x
        
        // 默认情况 : 选中最前面的标题按钮
        firstBtn.isSelected = true
        selectedTitleButton = firstBtn
    
    }
    
    @objc private func titleClick(btn:UIButton) {
        if btn == selectedTitleButton {
            //重新点中
        }
        selectedTitleButton?.isSelected = false
        btn.isSelected = true
        selectedTitleButton = btn
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
           self.indicatorView?.frame.size.width = (btn.titleLabel?.frame.size.width)!
            self.indicatorView?.center.x = btn.center.x
        })
         var offset = scrollView?.contentOffset
        offset?.x = CGFloat(CGFloat(btn.tag) * (scrollView?.frame.size.width)!)
        scrollView?.setContentOffset(offset!, animated: true)
        
    }
    
    private func addChildVcView(){
        let index = Int((scrollView?.contentOffset.x)! / (scrollView?.frame.size.width)!)
        let childVC = childViewControllers[index]
        if childVC.isViewLoaded{
            return
        }
        childVC.view.frame = (scrollView?.bounds)!
        scrollView?.addSubview(childVC.view)
        
    }
    
    //MARK: uicrollViewDelegate
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        addChildVcView()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        let btn = titleView.subviews[index]
    
        titleClick(btn: btn as! UIButton)
        addChildVcView()
    }
    
}
