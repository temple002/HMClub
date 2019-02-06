//
//  HMRefreshControl.swift
//  hm微博
//
//  Created by Temple on 16/9/28.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

// 设置放手刷新的临界点
let refreshOffset: CGFloat = 80

// 状态
enum HMRefreshState{
    // 正常
    case normal
    // 超过临界点
    case pulling
    // 将要刷新
    case willRefresh
}

/// 自定义刷新控件，控制刷新控件的类
class HMRefreshControl: UIControl {
    
    //滚动视图共同的父类：UIScrollView
    weak var scrollView: UIScrollView?
    
    // 刷新视图
    lazy var refreshview: HMRefreshview = HMRefreshview.refreshview()
    
    //构造函数: 调用控件的父类方法一定要是这个，因为控件需要大小
    init() {
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    
    //当添加和释放时都会调用
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        // 记录父视图
        scrollView = sv
        
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    // 移除KVO
    override func removeFromSuperview() {
        
        // 在父视图被释放前删除KVO监听
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let sv = scrollView else {
            return
        }
        
        // 计算刷新控件的高度
        let height = -(sv.contentOffset.y + sv.contentInset.top)
        
        if height < 0 {
            return
        }
        
        // 如果正在刷新，则不传递高度。
        if refreshview.refreshState != .willRefresh {
            // 把高度传给子视图
            refreshview.parentViewHeight = height
        }
        
        
        // 刷新的临界值
        if sv.isDragging {
            
            if height > refreshOffset && (refreshview.refreshState == .normal) {
                // 放手刷新
                refreshview.refreshState = .pulling
                
            }else if height <= refreshOffset && (refreshview.refreshState == .pulling){
                // 使劲
                refreshview.refreshState = .normal
            }
        }else{
            // 放手
            if refreshview.refreshState == .pulling {
                
                beginRefreshing()
                
                // 触发valueChanged监听
                sendActions(for: .valueChanged)
            }
        }
        
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv.bounds.width,
                            height: height)
    }
    
    
    func beginRefreshing() {
        print("开始刷新")
        
        guard let sv = scrollView else {
            return
        }
        
        // 如果正在刷新，则不重复操作
        if refreshview.refreshState == .willRefresh {
            return
        }
        
        refreshview.refreshState = .willRefresh
        
        // 调整表格上间距，让refreshView在加载完数据前一直显示
        var inset = sv.contentInset.top
        inset += refreshOffset
        
        sv.contentInset.top = inset
        
        // 设置刷新视图的父视图高度
        refreshview.parentViewHeight = refreshOffset
    }

    func endRefreshing() {
        print("停止刷新")
        
        guard let sv = scrollView else {
            return
        }
        
        // 如果当前状态不是刷新中的话，不执行下列操作
        if refreshview.refreshState != .willRefresh {
            return
        }
        
        // 恢复表格contentInset
        var inset = sv.contentInset
        inset.top -= refreshOffset
        sv.contentInset = inset
        
        // 恢复状态
        refreshview.refreshState = .normal
        
    }
}

extension HMRefreshControl{
     func setupUI() {
        
        self.backgroundColor = superview?.backgroundColor
    
        // 加载xib视图，默认的宽高是xib设置的宽高
        addSubview(refreshview)
        
        /// 自动布局 (设置xib自动布局，需要宽高约束)
        refreshview.translatesAutoresizingMaskIntoConstraints = false
        
        // 中心约束
        addConstraint(NSLayoutConstraint(item: refreshview,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        // 底部约束
        addConstraint(NSLayoutConstraint(item: refreshview,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        // 宽高约束
        addConstraint(NSLayoutConstraint(item: refreshview,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshview.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshview,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshview.bounds.height))
        
        
    }
}
