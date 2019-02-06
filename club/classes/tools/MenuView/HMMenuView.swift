//
//  HMMenuView.swift
//  club
//
//  Created by Temple on 16/10/22.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

protocol HMMenuViewDelegate: NSObjectProtocol {
    
    /// 选中按钮的代理
    ///
    /// - parameter menuView:    self
    /// - parameter selectedBtn: 选中按钮
    func menuViewDidSelectedItem(menuView: HMMenuView, selectedBtn: UIButton)
}

class HMMenuView: UIScrollView {

    weak var selectedDelegate: HMMenuViewDelegate?
    
    /// 文字底部动态线
    lazy var bottomLine: UIView = {
       
        let view = UIView()
        view.backgroundColor = HMThemeColor
        
        return view
    }()
    
    /// 数据源
    var menus: [String]?{
        
        didSet{
            
            if menus?.count == 0 {
                return
            }
            var offsetX: CGFloat = 0
            
            for title in menus ?? [] {
                
                let menubtn = UIButton()
                menubtn.setTitle(title, for: .normal)
                menubtn.titleLabel?.font = UIFont.systemFont(ofSize: HMMenuBtnTitleFontSize)
                menubtn.setTitleColor(HMMenuBtnDefaultColor, for: .normal)
                menubtn.setTitleColor(HMMenuBtnSelectedColor, for: .selected)
                menubtn.titleLabel?.textAlignment = .center
                
                
                let size = (title as NSString).boundingRect(with:CGSize(width: CGFloat(MAXFLOAT),height: 40),
                                                           options: .usesLineFragmentOrigin,
                                                           attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: HMMenuBtnTitleFontSize)],
                                                           context: nil)
                
                menubtn.frame = CGRect(x: offsetX + 15, y: 15, width: size.width, height: size.height)
                
                addSubview(menubtn)
                
                offsetX += menubtn.bounds.width + 15
                
                // 添加监听
                menubtn.addTarget(self, action: #selector(menuBtnClick(menuBtn:)), for: .touchUpInside)
            }
            
            self.contentSize = CGSize(width: offsetX, height: 0)
            
            updateBottomLine(menuBtn: nil)
            //让添加按钮的scroll可以滑动
            panGestureRecognizer.delaysTouchesBegan = true
        }
    }
    
    
    /// 菜单按钮点击事件
    ///
    /// - parameter menuBtn: menuBtn
    @objc func menuBtnClick(menuBtn: UIButton) {
        
        //代理方法
        selectedDelegate?.menuViewDidSelectedItem(menuView: self, selectedBtn: menuBtn)
        
        updateBottomLine(menuBtn: menuBtn)
    }
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.backgroundColor = #colorLiteral(red: 0.9833728671, green: 0.9833957553, blue: 0.9833834767, alpha: 1)
        
        //让添加按钮的scroll可以滑动
        panGestureRecognizer.delaysTouchesBegan = true
        
        //取消滚动指示器
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        // 选中第一个
        updateBottomLine(menuBtn: nil)
    }
}


// MARK: - 界面相关
extension HMMenuView{
    
    
    /// 更新底部线条位置
    func updateBottomLine(menuBtn: UIButton?) {
        
        var width: CGFloat = 0
        let height: CGFloat = 2
        var x: CGFloat = 0
        let y: CGFloat = 38
        
        // 先全部还原成默认值
        for btn in subviews {
            
            if !btn.isMember(of: UIButton.self) {
                continue
            }
            (btn as! UIButton).titleLabel?.font = UIFont.systemFont(ofSize: HMMenuBtnTitleFontSize)
            (btn as! UIButton).isSelected = false
        }
        
        // 如果为空，则为刚启动，默认选择第一个
        if menuBtn == nil {
            
            if menus?.count == 0 {
                return
            }
            for item in subviews {
                if item.isMember(of: UIButton.self) {
                    let btn = item as! UIButton
                    btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: HMMenuBtnTitleFontSize)
                    
                    btn.isSelected = true
                    
                    width = btn.bounds.width
                    x = btn.frame.origin.x
                    bottomLine.frame = CGRect(x: x, y: y, width: width, height: height)
                    
                    addSubview(bottomLine)
                    
                    break
                }
            }
            
            
        }else{
            
            guard let menuBtn = menuBtn else {
                return
            }
            
            menuBtn.isSelected = true
            
            menuBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: HMMenuBtnTitleFontSize)
            width = menuBtn.bounds.width
            x = menuBtn.frame.origin.x
            
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomLine.frame = CGRect(x: x, y: y, width: width, height: height)
            })
            
        }
    }
}
















