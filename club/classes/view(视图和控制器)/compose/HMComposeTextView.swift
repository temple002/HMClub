//
//  HMComposeTextView.swift
//  club
//
//  Created by Temple on 16/11/2.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

/// 发布动态界面
class HMComposeTextView: UITextView {

    lazy var placeHolderLabel = UILabel()
    
    override func awakeFromNib() {
        setupUI()
    }
    
    // textView监听
    @objc func textChange() {
        
        placeHolderLabel.isHidden = self.hasText
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 界面
fileprivate extension HMComposeTextView{
    
    func setupUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        placeHolderLabel.text = "说点什么..."
        placeHolderLabel.font = self.font
        placeHolderLabel.textColor = UIColor.lightGray
        
        placeHolderLabel.frame.origin = CGPoint(x: 5, y: 8)
        placeHolderLabel.sizeToFit()
        
        addSubview(placeHolderLabel)
    }
}
