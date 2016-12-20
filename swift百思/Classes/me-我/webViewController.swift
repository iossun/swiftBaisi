//
//  webViewController.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/29.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit
import SnapKit

class webViewController: UIViewController {

    var url:String? = nil
    var webView:UIWebView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = UIWebView()
        webView? .loadRequest(URLRequest(url: URL(string:url!)!))
        webView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 44)
        view.addSubview(webView!)
        SMLog(message: view.frame.size.width)
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
       //        let toolBar = UIToolbar(frame: CGRect(x: 0, y: view.frame.size.height - 44, width: view.frame.size.width, height: 44))
       //        toolBar.backgroundColor = UIColor.red
        //view.insertSubview(toolBar, at: 0)

    }
    @IBAction func reload(_ sender: Any) {
        webView?.reload()
    }
    
    @IBAction func back(_ sender: Any) {
        webView?.goBack()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forward(_ sender: Any) {
        webView?.goForward()
    }
    deinit {
        SMLog(message: "webView销毁了")
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
