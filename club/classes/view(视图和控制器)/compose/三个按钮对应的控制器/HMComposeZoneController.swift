//
//  HMComposeZoneController.swift
//  club
//
//  Created by Temple on 16/11/2.
//  Copyright © 2016年 Temple. All rights reserved.
//

import UIKit
import SVProgressHUD
import IQKeyboardManager
import ImagePicker
/// 发布动态控制器
class HMComposeZoneController: UIViewController {

    /// 输入框
    @IBOutlet weak var textView: HMComposeTextView!
    /// 工具栏
    @IBOutlet weak var toolbar: UIToolbar!
    // 工具栏底部约束
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    /// 预览
    @IBOutlet weak var zonePicsPreview: UIImageView!
    /// 当视频选择好了之后显示一个提示用语
    @IBOutlet weak var selectVideoLabel: UILabel!
    
    /// 图片集合
    var zonePics = [UIImage]()
    /// 记录图片相对路径（包含日期）
    var picPath = [String]()
    /// 记录视频位置
    var vidioPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 关闭IQKeyboardManager工具栏
        textView.inputAccessoryView = UIView()
        
        setupUI()
        
        // 添加键盘监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textChange() {
        sendButton.isEnabled = textView.hasText
    }
    
    // 键盘改变通知
    @objc func keyboardChange(n: Notification){
        
        // 键盘移动的距离UIKeyboardFrameEndUserInfoKey
        // 键盘弹出的时间UIKeyboardAnimationDurationUserInfoKey = 0.25
        
        guard let rect = (n.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.cgRectValue,
            let duration = (n.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? NSNumber)?.doubleValue
        else{
            return
        }
        
        // 更改约束
        toolbarBottomCons.constant = view.bounds.height - rect.origin.y
        
        UIView.animate(withDuration: duration) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    
    // 当视图显示时，textView处于编辑状态
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    lazy var sendButton: UIButton = {
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 35))
        
        btn.setTitle("发布", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        // 背景为橘黄色时，文字颜色为白色
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .disabled)
        
        // 设置背景
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange"), for: .normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange_highlighted"), for: .highlighted)
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_white_disable"), for: .disabled)
        
        // 添加监听
        btn.addTarget(self, action: #selector(postZone), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func close() {
        
        view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
    
    /// 发布动态
    @objc func postZone() {
        
        // 保存图片到本地
        let picPath = HMDBManager.shared.saveToSandBox(images: zonePics)
        
        HMDBManager.shared.postZone(videoPath: vidioPath, zonePics: picPath, text: textView.text!)
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.showSuccess(withStatus: "发布成功")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
            SVProgressHUD.dismiss()
            
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: { 
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMZonePushSeccessNotification), object: nil)
            })
        }
    }
    
    // 选择相册图片
    @objc func selectPic() {
        
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 9
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // 选择视频
    @objc func selectVideo() {
        
        let videoPicker = UIImagePickerController()
        videoPicker.sourceType = .photoLibrary
        videoPicker.mediaTypes = ["public.movie"]
        
        videoPicker.delegate = self
        present(videoPicker, animated: true, completion: nil)
    }

}

// MARK: - 获取视频
extension HMComposeZoneController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        // 显示文字提示用户视频已经上传
        self.selectVideoLabel.isHidden = false
        
        // UIImagePickerControllerMediaURL
        guard let vedioUrl = info[UIImagePickerControllerMediaURL] as? NSURL,
            let data = NSData(contentsOf: vedioUrl as URL)
        else{
            return
        }
        
        /// 获取现在的时间
        let date = Date()
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateformater.string(from: date)
        
        let fileName = String(format: "%@_test.mov", dateString)
        
        let isSuccess = data.write(toFile: (fileName as NSString).cz_appendDocumentDir(), atomically: true)
        print(isSuccess)
        
        // 记录这个文件夹和下面的图片
        vidioPath = fileName
        
    }
    
}

/// 图片选择器代理
extension HMComposeZoneController: ImagePickerDelegate{
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        imagePicker.dismiss(animated: true){
            
            let str = String(format: "%d张", images.count)
            guard let lastimg = images.last else{
                return
            }
            self.zonePicsPreview.image = lastimg.waterMarkedImage(waterMarkText: str)
            self.zonePicsPreview.isHidden = false
            
            self.zonePics = images
        }
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true){}
    }
    
    
}

// MARK: - 界面
fileprivate extension HMComposeZoneController{
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        
        self.title = "发布动态"
        
        setupNav()
        setupToolBar()
    }
    
    /// 导航栏设置
    func setupNav() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        sendButton.isEnabled = false
        
    }
    
    // 工具栏
    func setupToolBar() {
        
        // 工具栏图片数组
        let itemSettings = [["imageName": "compose_toolbar_picture", "actionName": "selectPic"],
                            ["imageName": "Watch-24", "actionName": "selectVideo"]
                            ]
        
        var toolBarItems = [UIBarButtonItem]()
        
        // 遍历数组
        for item in itemSettings {
            
            let button = UIButton()
            
            guard let imageName = item["imageName"],
                let image = UIImage(named: imageName),
                let imageHL = UIImage(named: imageName + "_highlighted") else{
                    continue
            }
            
            button.setImage(image, for: .normal)
            button.setImage(imageHL, for: .highlighted)
            
            button.sizeToFit()
            
            // 添加监听
            if let actionName = item["actionName"] {
                
                button.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            toolBarItems.append(UIBarButtonItem(customView: button))
        }
        
        toolbar.items = toolBarItems
    }
}
