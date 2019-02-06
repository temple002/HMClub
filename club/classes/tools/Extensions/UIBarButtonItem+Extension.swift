//
//  UIBarButtonItem+Extension.swift
//  hm微博
//
//  Created by Temple on 16/8/21.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    convenience init(title: String, fontSize: CGFloat = 16, target: AnyObject?, action: Selector, isBack: Bool = false) {
        
        
        let btn: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: HMThemeColor)
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        if isBack == true {
            
            let NormalImage = UIImage(named: "navigationbar_back_withtext")
            let highlightedImage = UIImage(named: "navigationbar_back_withtext_highlighted")
            
            btn.setImage(NormalImage, for: .normal)
            btn.setImage(highlightedImage, for: .highlighted)
            
            btn.sizeToFit()
        }
        
        //初始化自己
        self.init(customView: btn)
        
    }
}
