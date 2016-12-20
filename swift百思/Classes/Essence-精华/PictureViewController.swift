//
//  SMPictureViewController.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/24.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

class PictureViewController: TopicViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view.
     }
    override func type() -> (Int) {
        return topicType.TopicTypePicture.rawValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
