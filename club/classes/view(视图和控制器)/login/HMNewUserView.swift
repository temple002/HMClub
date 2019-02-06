//
//  HMNewUserView.swift
//  club
//
//  Created by Temple on 16/11/5.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMNewUserView: UIView {

    lazy var scrollview: UIScrollView = UIScrollView()
    
    /// 注册完成的block
    var completeRegistBlock: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 界面
fileprivate extension HMNewUserView{
    
    func setupUI() {
        
        
        // 如果使用自动布局设置的界面，从 XIB 加载默认是 600 * 600 大小
        let rect = UIScreen.main.bounds
        
        scrollview.frame = rect
        addSubview(scrollview)
        
        // 注册完成的闭包
        let registView = HMRegistView.registView {
            self.scrollview.setContentOffset(CGPoint(x: rect.width, y: 0), animated: true)
        }
        registView.frame = rect
        scrollview.addSubview(registView)
        
        // 选择完喜爱的社团的闭包
        let recommentView = HMClubRecommend.ClubRecommendView { 
            self.scrollview.setContentOffset(CGPoint(x: 2 * rect.width, y: 0), animated: true)
            
            /// 移除自己并上传用户所喜欢的社团信息
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: { 
                
                // 注册完成执行block
                self.completeRegistBlock?()
                
                self.removeFromSuperview()
            })
        }
        recommentView.frame = rect.offsetBy(dx: rect.width, dy: 0)
        
        scrollview.addSubview(recommentView)
        
        
        // 指定 scrollView 的属性
        scrollview.contentSize = CGSize(width: CGFloat(3) * rect.width, height: rect.height)
        
        scrollview.isScrollEnabled = false
        scrollview.backgroundColor = UIColor.clear
        scrollview.bounces = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.showsHorizontalScrollIndicator = false
    }
}





