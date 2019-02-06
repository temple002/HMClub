//
//  HMClubDetailController.swift
//  club
//
//  Created by Temple on 16/11/8.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import pop
class HMClubDetailController: UIViewController {

    /// scrollView
    @IBOutlet weak var scrollview: UIScrollView!
    /// 社团logo
    @IBOutlet weak var clubLogo: UIImageView!
    /// 社团标题
    @IBOutlet weak var clubTitle: UILabel!
    /// 加入社团
    @IBOutlet weak var joinClub: UIButton!
    /// 社团描述
    @IBOutlet weak var clubDes: UITextView!
    /// 社团类型
    @IBOutlet weak var clubType: UILabel!
    /// 社团历史活动
    @IBOutlet weak var clubHisEvetn: UIView!
    
    /// club模型
    var clubModel: HMClub?
    
    /// 申请理由弹窗
    lazy var applyView: HMApplyView = HMApplyView.applyView { [weak self] in
        
        self?.joinClub.isSelected = true
        
        self?.joinClub.backgroundColor = UIColor.lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    /// 在视图将要显示的时候加载数据
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let url = NSURL(fileURLWithPath: documentPath.appendingPathComponent((clubModel?.clubLogoPic)!))
        clubLogo.sd_setImage(with: url as URL)
        clubType.text = clubModel?.clubType ?? ""
        clubTitle.text = clubModel?.clubTitle ?? ""
        clubDes.text = clubModel?.clubDes ?? ""
        
        title = clubModel?.clubTitle
        
        navigationController?.navigationBar.isHidden = true
        
        /// 检查申请状态
        checkApplyState()
    }

    /// 查看历史活动
    @objc func hisEventClick(tap: UITapGestureRecognizer) {
        
        guard let clubTitle = clubModel?.clubTitle else {
            return
        }
        
        let vc = HMClubEventsController()
        vc.clubTitle = clubTitle
        vc.title = "历史活动"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 返回按钮
    @IBAction func backClick() {
        
        let _ = navigationController?.popViewController(animated: true)
    }
    
    /// 参加社团
    @IBAction func joinClick() {
        
        applyView.clubTitle = clubTitle.text
        view.addSubview(applyView)
        
        setupApplyView()
    }
}

// MARK: - 数据库相关
extension HMClubDetailController{
    
    /// 检查申请状态，如果已经申请成功，则隐藏申请按钮
    func checkApplyState() {
        
        guard let clubModel = clubModel else {
            return
        }
        
        HMDBManager.shared.loadMyApplyedClub { (clubs) in
            
            for club in clubs{
                
                if club.clubTitle != clubModel.clubTitle {
                    continue
                }
                
                guard let state = club.state else{
                    break
                }
                
                // 隐藏joinclub按钮
                self.joinClub.isHidden = (state == "审核通过")
                
                self.joinClub.setTitle(state, for: .normal)
                self.joinClub.isSelected = true
                self.joinClub.backgroundColor = UIColor.lightGray
            }
        }
    }
}

// MARK: - 界面
extension HMClubDetailController{
    
    /// 设置申请理由弹窗的UI
    fileprivate func setupApplyView() {
        
        let width: CGFloat = 269
        let height: CGFloat = 249
        let x = (UIScreen.cz_screenWidth() - width) / 2
        let y = (UIScreen.cz_screenHeight() - height) / 2
        
        applyView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        
        anim?.fromValue = applyView.center.y + 100
        anim?.toValue = applyView.center.y
        
        // 弹力[0-20]
        anim?.springBounciness = 8
        // 动画速度[0-20]
        anim?.springSpeed = 12
        
        applyView.layer.pop_add(anim, forKey: nil)
        
    }
    
    fileprivate func setupUI() {
        
        navigationController?.navigationBar.isHidden = true
        scrollview.contentInset.top = -20
        
        clubLogo.layer.cornerRadius = 60
        clubLogo.layer.borderWidth = 2
        clubLogo.layer.borderColor = UIColor.white.cgColor
        
        joinClub.layer.cornerRadius = 2
        
        // 给社团历史活动添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hisEventClick))
        clubHisEvetn.addGestureRecognizer(tapGes)
    }
    
}
