//
//  HMCreatedClubDetailController.swift
//  club
//
//  Created by Temple on 16/11/11.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit

class HMCreatedClubDetailController: UIViewController {

    /// scrollView
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var clublogo: UIImageView!
    @IBOutlet weak var clubTitle: UILabel!
    
    // 接收club数据
    var club: HMClub?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "社团管理"
        
        navigationController?.navigationBar.isHidden = true
        scrollview.contentInset.top = -20
        
        clublogo.layer.cornerRadius = 60
        clublogo.layer.borderColor = UIColor.white.cgColor
        clublogo.layer.borderWidth = 2
    }
    
    /// 在视图显示的时候设置值
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let url = NSURL(fileURLWithPath: documentPath.appendingPathComponent((club?.clubLogoPic)!))
        clublogo.sd_setImage(with: url as URL)
        clubTitle.text = club?.clubTitle ?? ""
    }
    
    // 返回
    @IBAction func backClick() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    /// 社团活动查询
    @IBAction func clubEventClick() {
        
        let clubEventsVC = HMClubEventsController()
        clubEventsVC.title = "社团活动查询"
        clubEventsVC.clubTitle = club?.clubTitle
        navigationController?.pushViewController(clubEventsVC, animated: true)
    }
    /// 社团成员
    @IBAction func clubMemberClick() {
        let clubMemberVC = HMClubMemberController()
        clubMemberVC.title = "社团成员"
        clubMemberVC.clubTitle = club?.clubTitle
        navigationController?.pushViewController(clubMemberVC, animated: true)
    }
    /// 社团通知
    @IBAction func clubNoteClick() {
        let noteVC = HMNoteController()
        noteVC.title = "社团通知"
        noteVC.clubTitle = club?.clubTitle
        navigationController?.pushViewController(noteVC, animated: true)
    }
    /// 发布通知
    @IBAction func pushNoteClick() {
        
        let pushNoteVC = HMPushNoteController()
        pushNoteVC.title = "发布通知"
        pushNoteVC.clubTitle = club?.clubTitle
        present(UINavigationController(rootViewController: pushNoteVC), animated: true, completion: nil)
    }
    /// 申请入社管理
    @IBAction func checkManagerClick() {
        
        let checkApplyVC = HMCheckApplyController()
        checkApplyVC.title = "申请入社管理"
        checkApplyVC.clubTitle = club?.clubTitle
        navigationController?.pushViewController(checkApplyVC, animated: true)
    }
    /// 社团设置
    @IBAction func clubSettingClick() {
        print("社团设置")
    }
}
