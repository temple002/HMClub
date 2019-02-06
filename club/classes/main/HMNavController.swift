//
//  HMNavController.swift
//  club
//
//  Created by Temple on 16/10/22.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = HMThemeColor
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
}
