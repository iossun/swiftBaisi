//
//  SMQEcodeViewController.swift
//  swift百思
//
//  Created by 蛮牛科技 on 16/11/25.
//  Copyright © 2016年 孙慕. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate{
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    //容器视图
    @IBOutlet weak var customContainerView: UIView!
    //冲击波约束
    @IBOutlet weak var scanLineTopCons: NSLayoutConstraint!
    @IBOutlet weak var customTabbar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        customTabbar.selectedItem = customTabbar.items?[0]
        modalPresentationStyle = .custom;
        
       }
    
    override func viewDidAppear(_ animated: Bool) {
        //开启扫描动画
        startAnimation()
        
        //开始扫描二维码
        startScan()
    }
    
    private func startAnimation(){
        // 2.1让冲击波初始化到顶部
        scanLineTopCons.constant = -contentHeight.constant
        self.customContainerView.layoutIfNeeded()
 
          //2.2重复动画
        
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            UIView.setAnimationRepeatCount(MAXFLOAT)

            self.scanLineTopCons.constant = self.contentHeight.constant
            self.customContainerView.layoutIfNeeded()
           
          })
       }
    
    
    private func startScan(){
        // 1.判断输入能否添加到会话中
        if !session.canAddInput(input)
        {
            return
        }
        // 2.判断输出能否添加到会话中
        if !session.canAddOutput(output)
        {
            return
        }
        // 3.添加输入和输出
        session.addInput(input)
        session.addOutput(output)
        
        // 4.告诉系统输出可以解析的数据类型
        // 注意点:设置可以解析数据类型一定要在输出对象添加到会话之后设置, 否则就会报错
        output.metadataObjectTypes =  [AVMetadataObjectTypeQRCode]
        // 5.设置代理监听解析结果
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // 6.添加预览图层
        view.layer.insertSublayer(preViewlayer, at: 0)
        view.layer.insertSublayer(drawLayer, above: preViewlayer)
       // view.layer.addSublayer(drawLayer)
        
        // 7.开始扫描
        session.startRunning()
        
      }
    
    // MARK: - 懒加载
    /// 创建输入
    private lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let deviceInput = try? AVCaptureDeviceInput(device: device)
        return deviceInput
    }()
    /// 创建输出
    private lazy var output: AVCaptureMetadataOutput = {
        let out = AVCaptureMetadataOutput()
        // 注意: 该属性接收的不是坐标, 而是比例
        // 注意: 该属性并不是以竖屏的左上角作为参照, 而是以横屏的左上角作为参照
        // 所以计算时, x就变成了y, y就变成了x, width就变成了height, height就变成了width
        //        out.rectOfInterest = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
        
        // 1.屏幕的frame
        let rect = self.view.frame
        // 2.容器视图的frame
        let containerRect = self.customContainerView.frame
        out.rectOfInterest = CGRect(x: containerRect.origin.y / rect.size.height, y: containerRect.origin.x / rect.size.width , width: containerRect.size.height / rect.size.height , height: containerRect.size.width / rect.size.width)
        
        SMLog(message: out.rectOfInterest)
        return out
    }()
    private lazy var session:AVCaptureSession = AVCaptureSession()
    
    private lazy var preViewlayer:AVCaptureVideoPreviewLayer = {
      let layer = AVCaptureVideoPreviewLayer(session: self.session)
         layer?.frame = self.view.bounds
        return layer!
    }()
    
    /// 创建保存二维码边线的图层
    private lazy var drawLayer: CALayer = {
        let layer = CALayer()
        layer.frame = self.view.bounds
        return layer
    }()
    

    
    
    
    

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
         session.stopRunning()
    }
    
    // MARK: - 二维码输出回调
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
         guard (metadataObjects.last as AnyObject).stringValue != nil  else {
             resultLabel.text =  "将二维码/条形码放入框中即可扫描"
            clearLines()
            return
        }
        resultLabel.text = (metadataObjects.last as AnyObject).stringValue as String
        
        clearLines()
        
        // 1.遍历结果集
        for objc in metadataObjects as! [AVMetadataMachineReadableCodeObject]
        {
            // 2.将结果集中的对象中保存的corners坐标, 转换为我们能够识别的坐标
            let res = preViewlayer.transformedMetadataObject(for: objc)
            
            // 3.绘制二维码边线
            drawLines(cornersObjc: res as! AVMetadataMachineReadableCodeObject)
        }
    }
    
    // MARK: - 绘制二维码边线
    private func drawLines(cornersObjc: AVMetadataMachineReadableCodeObject)
    {
        // 0.进行安全校验
        guard let corners = cornersObjc.corners else
        {
            return
        }
        
        // 1.创建CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4
        
        // 2.创建路径
        let path = UIBezierPath()
        
        // 定义变量保存从corners取出来得结果
        var point = CGPoint()
        
        // 定义变量记录索引
        var index = 0
        
        // 2.1移动到起点
        point = CGPoint.init(dictionaryRepresentation: (corners[index] as! CFDictionary))!
        
        path.move(to: point)
        
        // 2.2连接其它的点
        while index < corners.count
        {
            point = CGPoint.init(dictionaryRepresentation: (corners[index] as! CFDictionary))!
            path.addLine(to: point)
            index += 1

        }
        
        path.close()
        
        shapeLayer.path = path.cgPath
        
        // 3.将绘制好得图层添加到drawLayer
        drawLayer.addSublayer(shapeLayer)
    }
    /// 清空二维码边线
    private func clearLines()
    {
        // 1.检查有没有子图层
        guard let subLayers = drawLayer.sublayers else
        {
            return
        }
        
        // 2.删除子图层
        for layer in subLayers
        {
            layer.removeFromSuperlayer()
        }

    }
    
}


