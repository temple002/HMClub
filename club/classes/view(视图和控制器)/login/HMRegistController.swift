//
//  HMRegistController.swift
//  club
//
//  Created by Temple on 16/11/4.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMRegistController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
    }
}

// MARK: - 界面
fileprivate extension HMRegistController{
    
    func setupUI() {
        
        title = "注册新用户"
        view.backgroundColor = HMThemeBgColor
        
        
    }
}
