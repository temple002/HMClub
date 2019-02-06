//
//  HMMeituanRefreshView.swift
//  L23-刷新控件
//
//  Created by Temple on 16/10/3.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMMeituanRefreshView: HMRefreshview {

    // 房子背景
    @IBOutlet weak var buildingView: UIImageView!
    // 地球
    @IBOutlet weak var earthView: UIImageView!
    // 袋鼠
    @IBOutlet weak var kangarooView: UIImageView!
    
    // 重写父类计算型属性
    override var parentViewHeight: CGFloat{
        didSet{
            
            // 计算scale
            var scale: CGFloat = 0
            
            if parentViewHeight < 23 {
                return
            }
            
            if parentViewHeight > 126 {
                scale = 1
            }else{
                scale = 1 - ((126 - parentViewHeight) / (126 - 25))
            }
            
            kangarooView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    override func awakeFromNib() {
        
        /// 设置背景动图
        let bgIcon1 = #imageLiteral(resourceName: "icon_building_loading_1")
        let bgIcon2 = #imageLiteral(resourceName: "icon_building_loading_2")
        
        buildingView.image = UIImage.animatedImage(with: [bgIcon1, bgIcon2], duration: 0.3)
        
        /// 地球动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 3
        anim.isRemovedOnCompletion = false
        
        earthView.layer.add(anim, forKey: nil)
        
        /// 袋鼠
        // 设置动画
        let kgIcon1 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_1")
        let kgIcon2 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_2")
        
        kangarooView.image = UIImage.animatedImage(with: [kgIcon1, kgIcon2], duration: 0.3)
        
        kangarooView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        
        // 先设置锚点在设置frame
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - 25
        
        kangarooView.center = CGPoint(x: x, y: y)
        
    }
}
