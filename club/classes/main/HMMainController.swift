//
//  HMMainController.swift
//  club
//
//  Created by Temple on 16/10/22.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import SVProgressHUD

class HMMainController: UITabBarController {

    /// 撰写按钮
    fileprivate lazy var composeButton: UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add",
                                                                       backgroundImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildControllers()
        setupComposeButton()
        
        /// tabbarController代理
        delegate = self
        
        // 注册通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userLogin),
            name: NSNotification.Name(rawValue: HMUserShouldLoginNotification),
            object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(needCreateClub), name: NSNotification.Name(rawValue: HMUserNeedCreateClubNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectZonePage), name: NSNotification.Name(rawValue: HMZonePushSeccessNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectEventPage), name: NSNotification.Name(rawValue: HMEventPushSeccessNotification), object: nil)
        
        // 设置用户信息
        if HMDBManager.shared.isLogin == true {
            
            HMDBManager.shared.loadUserInfo(completion: { (user) in
            })
            
        }else{
            
            // 如果没注册，则显示注册界面
            let newUserView = HMNewUserView()
            newUserView.frame = view.bounds
            
            view.addSubview(newUserView)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    //只支持竖屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    /// 选择event控制器界面
    @objc func selectEventPage() {
        
        selectedIndex = 0
        
        // 发出通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMEventNeedRefreshNotification), object: nil)
    }
    
    /// 选择zone控制器界面
    @objc func selectZonePage() {
        
        selectedIndex = 1
        
        // 发出通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMZoneNeedRefreshNotification), object: nil)
    }
    
    // 登录操作
    @objc func userLogin() {
        
        let vc = HMLoginViewController()
        
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true, completion: nil)
    }
    
    /// 提示用户不能创建活动，因为没有创建社团
    @objc func needCreateClub() {
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.showError(withStatus: "你还未创建社团，不能发布活动")
    }
    
    /// 加号按钮点击事件
    func composeClick() {
        
        let composeListView = HMComposeListView.composeListView()
        
        // 展示控制器，并回调
        composeListView.show {[weak composeListView] (clsName) in
            
            // 如果没登录，则要求登录
            if HMDBManager.shared.isLogin == false {
                
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: HMUserShouldLoginNotification),
                    object: nil)
                composeListView?.hideButtons()
                return
            }
            
            // 如果创建活动，则判断他是否有权利发布活动
            if clsName == "HMComposeEventController" {
                
                if HMDBManager.shared.account.createdClubs.count < 1 {
                    NotificationCenter.default.post(
                        name: NSNotification.Name(rawValue: HMUserNeedCreateClubNotification),
                        object: nil)
                    
                    composeListView?.hideButtons()
                    return
                }
                
            }
            
            guard let clsName = clsName ,
                let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
            else{
                return
            }
            
            let vc = cls.init()
            let nav = UINavigationController(rootViewController: vc)
            
            // 在下面控制器出来之前，更新约束,解决toolBar从小放大动画问题
            nav.view.layoutIfNeeded()
            
            self.present(nav, animated: true, completion: { 
                composeListView?.removeFromSuperview()
            })
        }
    }
    
    
}

// MARK: - UITabBarControllerDelegate
extension HMMainController: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // 1> 获取控制器在数组中的索引
        let idx = (childViewControllers as NSArray).index(of: viewController)
        if idx == 4{
            
            // 判断是否登录
            let login = HMDBManager.shared.isLogin
            
            if login == false {
                
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: HMUserShouldLoginNotification),
                    object: nil)
                return false
            }
        }
        
        return true
    }
}

// MARK: - 设置子控制器
fileprivate extension HMMainController{
    
    /// 设置撰写按钮
    func setupComposeButton() {
        
        tabBar.addSubview(composeButton)
        
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * width, dy: 0)
        
        composeButton.addTarget(self, action: #selector(composeClick), for: .touchUpInside)
    }
    
    func setupChildControllers() {
        
        guard let jsonPath = Bundle.main.path(forResource: "main.json", ofType: nil),
            let data = NSData(contentsOfFile: jsonPath),
            let array = try? JSONSerialization.jsonObject(with: data as Data, options: []) as! [[String: AnyObject]]
            else{
                return
        }
        
        var controllers = [UIViewController]()
        
        for dict in array {
            
            controllers.append(controller(with: dict))
        }
        
        viewControllers = controllers
    }
    
    func controller(with dict: [String: AnyObject]) -> UIViewController {
        
        guard let clsName = dict["clsName"] as? String,
            let imageName = dict["imageName"] as? String,
            let title = dict["title"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
            else{
            return UIViewController()
        }
        
        let vc = cls.init()
        
        vc.title = title
        vc.tabBarItem.title = title
        // 3. 设置图像
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        // 4. 设置 tabbar 的标题字体（大小）
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: HMThemeColor], for: .highlighted)
        // 系统默认是 12 号字，修改字体大小，要设置 Normal 的字体大小
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 11)],for: UIControlState(rawValue: 0))
        
        return HMNavController(rootViewController: vc)
    }
}




