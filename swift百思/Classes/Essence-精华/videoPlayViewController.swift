//
//  videoPlayViewController.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/12/26.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

class videoPlayViewController: UIViewController {
    
    var URL:NSURL?
    
    var play:player!
    //hengping
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        play = player.init(frame: CGRect(x: 0, y: 150, width: view.frame.size.width, height: 300))
        play.videoURL = URL
        view.addSubview(play)
        
        //左上角
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named:"navigationButtonReturn"), for: UIControlState.normal)
        button.setImage(UIImage(named:"navigationButtonReturnClick"), for: UIControlState.highlighted)
        button.setTitle("返回", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.setTitleColor(UIColor.red, for: UIControlState.highlighted)
        button.sizeToFit()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 20, y: 30, width: 44, height: 44);
        view.addSubview(button)
        
        appDelegate.blockRotation = true
          // Do any additional setup after loading the view.
        
//        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
//        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
//        appDelegate.blockRotation = false
//        let value = UIInterfaceOrientation.Portrait.rawValue
//        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    @objc private func back(){
        appDelegate.blockRotation = false
        
        dismiss(animated: true, completion: nil)
    }

    deinit {
         appDelegate.blockRotation = false
    }
    

    

}
