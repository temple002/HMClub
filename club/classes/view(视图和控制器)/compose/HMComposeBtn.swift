//
//  HMComposeBtn.swift
//  club
//
//  Created by Temple on 16/11/1.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMComposeBtn: UIControl {

    /// 按钮图片
    @IBOutlet weak var composeIcon: UIImageView!
    /// 按钮文字
    @IBOutlet weak var composeTitle: UILabel!
    
    var clsName: String?
    
    
    /// 类方法快捷返回一个composebtn
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - imageName: 图片名称
    class func composebtn(title: String?, imageName: String? = "tabbar_compose_idea") -> HMComposeBtn{
        
        let nib = UINib.init(nibName: "HMComposeBtn", bundle: nil)
        
        let composeBtn = nib.instantiate(withOwner: nil, options: nil)[0] as! HMComposeBtn
        
        composeBtn.composeIcon.image = UIImage(named: imageName!)
        composeBtn.composeTitle.text = title ?? ""
        
        return composeBtn
    }

}
