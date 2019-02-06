//
//  HMComposeListView.swift
//  club
//
//  Created by Temple on 16/11/1.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import pop
class HMComposeListView: UIView {

    /// 展示composebtn的区域
    @IBOutlet weak var composeArea: UIView!
    
    /// 关闭按钮
    @IBAction func closeClick() {
        
        hideButtons()
    }
    
    /// 按钮数据数组
    let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "发布动态", "clsName": "HMComposeZoneController"],
                       ["imageName": "tabbar_compose_photo", "title": "发布活动", "clsName": "HMComposeEventController"],
                       ["imageName": "tabbar_compose_weibo", "title": "创建社团", "clsName": "HMComposeCreateController"]
    ]
    
    /// 便捷返回自身对象
    class func composeListView() -> HMComposeListView{
        
        let nib = UINib.init(nibName: "HMComposeListView", bundle: nil)
        
        let clv = nib.instantiate(withOwner: nil, options: nil)[0] as! HMComposeListView
        
        clv.frame = UIScreen.main.bounds
        
        // 设置布局
        clv.setupUI()
        
        return clv
    }

    var showCompletionBlock: ((_ clsName: String?)->())?
    
    /// 显示自身
    func show(completion: @escaping (_ clsName: String?)->()) {
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else{
            return
        }
        
        vc.view.addSubview(self)
        
        //记录闭包
        showCompletionBlock = completion
        
        // 设置动画
        listViewAnimation()
    }
    
    /// 按钮点击事件
    @objc func btnClick(btn: HMComposeBtn) {
        
        self.showCompletionBlock?(btn.clsName)
    }
}


// MARK: - 界面
extension HMComposeListView{
    
    fileprivate func setupUI() {
        
        let count = buttonsInfo.count
        
        for i in 0..<count {
            
            // 九宫格布局
            let outMargin = CGFloat(40)
            let width = CGFloat(60)
            let height = CGFloat(85)
            let innerMargin1 = (UIScreen.cz_screenWidth() - 2 * outMargin - CGFloat(count) * width)
            let innerMarin = innerMargin1 / (CGFloat(count) - 1)
            
            let x = outMargin + CGFloat(i) * (innerMarin + width)
            
            let dict = buttonsInfo[i]
            guard let title = dict["title"],
                let imageName = dict["imageName"],
                let clsName = dict["clsName"]
            else{
                    return
            }
            
            let btn = HMComposeBtn.composebtn(title: title, imageName: imageName)
            
            composeArea.addSubview(btn)
            
            btn.frame = CGRect(x: x, y: 0, width: width, height: height)
            
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            
            // 设置点击对应的控制器名
            btn.clsName = clsName
        }
    }
    
}

// MARK: - 动画
extension HMComposeListView{
    
    /// 当前视图上场动画
    fileprivate func listViewAnimation () {
        
        let anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim?.fromValue = 0
        anim?.toValue = 1.0
        anim?.duration = 0.5
        
        pop_add(anim, forKey: nil)
        
        buttonAnim()
    }
    
    /// 按钮飞入的动画
    fileprivate func buttonAnim() {
        
        for (i, btn) in (composeArea.subviews).enumerated(){
            
            let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim?.fromValue = btn.center.y + 350
            anim?.toValue = btn.center.y
            
            anim?.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.05
            // 弹力[0-20]
            anim?.springBounciness = 8
            // 动画速度[0-20]
            anim?.springSpeed = 8
            
            btn.layer.pop_add(anim, forKey: nil)
        }
    }
    
    // 隐藏按钮动画
    func hideButtons() {
        
        // 判断当前是第几页
        
        for (i, btn) in composeArea.subviews.enumerated() {
            
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.center.y
            anim.toValue = btn.center.y + 350
            
            // 动画速度[0-20]
            anim.springSpeed = 8
            
            // 间隔弹出
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(composeArea.subviews.count - i) * 0.025
            
            btn.layer.pop_add(anim, forKey: nil)
            
            // 最后一个完了之后开始隐藏当前视图
            if i == composeArea.subviews.count - 1 {
                anim.completionBlock = { _,_ in
                    self.hideCurrentView()
                }
            }
        }
    }
    
    // 隐藏当前视图
    fileprivate func hideCurrentView() {
        
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 1.0
        anim.toValue = 0.0
        anim.duration = 0.25
        
        pop_add(anim, forKey: nil)
        
        anim.completionBlock = { _,_ in
            self.removeFromSuperview()
        }
    }
}







