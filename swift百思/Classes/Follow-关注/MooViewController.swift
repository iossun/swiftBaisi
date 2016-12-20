//
//  SMooViewController.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/23.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit

class MooViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(UIViewController(), animated: true)
    }
    
    deinit {
        print("11111")
    }
}
