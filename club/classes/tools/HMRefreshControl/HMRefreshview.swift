//
//  HMRefreshview.swift
//  L23-刷新控件
//
//  Created by Temple on 16/9/29.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMRefreshview: UIView {

    // control的高度
    var parentViewHeight: CGFloat = 0

    // 设置状态
    var refreshState: HMRefreshState = .normal{
        didSet{
            
            /*
                UIView的动画默认是顺时针旋转，就近原则，所以要跳转一个非常小的数字
                如果要实现360°旋转，要用到核心动画
             */
            switch refreshState {
            case .normal :
                tipText?.text = "下拉开始刷新..."
                
                tipIcon?.isHidden = false
                indicator?.stopAnimating()
                
                UIView.animate(withDuration: 0.25, animations: { 
                    self.tipIcon?.transform = CGAffineTransform.identity
                })
                
            case .pulling :
                tipText?.text = "放手刷新..."
                
                UIView.animate(withDuration: 0.25, animations: { 
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI + 0.001))
                })
                
            case .willRefresh :
                tipText?.text = "正在刷新中..."
                
                tipIcon?.isHidden = true
                indicator?.startAnimating()
            }
        }
    }
    
    /// 刷新视图的箭头
    @IBOutlet weak var tipIcon: UIImageView?
    /// 刷新视图的文本
    @IBOutlet weak var tipText: UILabel?
    /// 刷新视图的指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    
    class func refreshview() -> HMRefreshview {
        
        let nib = UINib(nibName: "HMRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! HMRefreshview
    }
}
