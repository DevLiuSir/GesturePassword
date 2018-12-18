//
//  GesturePasswordViewController.swift
//  GesturePasswordExample
//
//  Created by Liu Chuan on 2018/3/29.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit


/// 手势密码key
private let GesturesPassword = "gesturespassword"
/// 边距X
private let maginX: CGFloat = 15
/// 间距
private let magin: CGFloat = 5
/// 按钮高度
private let btnH: CGFloat = 30
/// 按钮宽度
private let btnW: CGFloat = (screenW - maginX * 2 - magin * 2) / 3
/// 错误次数
private var errorCount: Int = 5

/// 手势密码控制器
class GesturePasswordViewController: UIViewController {
    
    /// 创建的手势密码
    var lastGesturePassword = ""
    
    /// 解锁类型(默认:创建手势密码)
    var unlockType = LCUnlockType.createPassword

    // MARK: - 懒加载
    /// 手势密码视图
    private lazy var gestureView: GesturePasswordView = {
        let gesture = GesturePasswordView(frame: CGRect(x: 0, y: 200, width: screenW, height: screenW))
        gesture.delegate = self
        return gesture
    }()
    
    /// 手势密码预览视图
    private lazy var gesturePreview: GesturePasswordPreview = {
        let gesturePreview = GesturePasswordPreview(frame: CGRect(x: (view.frame.size.width - 60) / 2, y: 100, width: 60, height: 60))
        return gesturePreview
    }()
    
    /// 用户头像
    private lazy var headIcon: UIImageView = {
        let head = UIImageView(frame: CGRect(x: gesturePreview.frame.minX, y: 40, width: gesturePreview.frame.width, height: gesturePreview.frame.height))
        head.image = UIImage(named: "solarized-yinyang")
        return head
    }()
    
    /// 手势状态栏提示label
    private lazy var statusLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: (view.frame.size.width - 200) * 0.5, y: 160, width: 200, height: 30))
        label.textAlignment = .center
        label.text = "请绘制手势密码"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .red
        return label
    }()
    
    /// 其他账户登录按钮
    private lazy var otherAcountBtn: UIButton = {
        let other = UIButton(type: .custom)
        other.frame = CGRect(x: maginX, y: view.frame.size.height - 20 - btnH, width: btnW, height: btnH)
        other.backgroundColor = UIColor.clear
        other.setTitle("其他账户", for: .normal)
        other.setTitleColor(UIColor.red, for: .normal)
        other.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        other.addTarget(self, action: #selector(otherAccountLogin), for: .touchUpInside)
        return other
    }()
    
    /// 重新绘制按钮
    private lazy var resetPassswordBtn: UIButton = {
        let reset = UIButton(type: .custom)
        reset.frame = CGRect(x: otherAcountBtn.frame.maxX + magin, y: otherAcountBtn.frame.origin.y, width: btnW, height: btnH)
        reset.backgroundColor = otherAcountBtn.backgroundColor
        reset.setTitle("重新绘制", for: .normal)
        reset.setTitleColor(UIColor.red, for: .normal)
        reset.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        reset.addTarget(self, action: #selector(resetGesturePassword), for: .touchUpInside)
        return reset
    }()
    
    /// 忘记手势密码按钮
    private lazy var forgetPasswordBtn: UIButton = {
        let forget = UIButton(type: .custom)
        forget.frame = CGRect(x: resetPassswordBtn.frame.maxX + magin, y: otherAcountBtn.frame.origin.y, width: btnW, height: btnH)
        forget.backgroundColor = otherAcountBtn.backgroundColor
        forget.isUserInteractionEnabled = true
        forget.setTitle("忘记密码", for: .normal)
        forget.setTitleColor(.red, for: .normal)
        forget.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        forget.addTarget(self, action: #selector(forgetGesturesPassword), for: .touchUpInside)
        return forget
    }()
    
    // MARK: - 自定义初始化方法
    ///
    /// - Parameter unlockType: 解锁类型
    public init(unlockType: LCUnlockType) {
        super.init(nibName: nil, bundle: nil)
        self.unlockType = unlockType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSub()
        handleDifferentUnlockState()
    }
}

// MARK: - 私有方法
extension GesturePasswordViewController {
    
    /// 添加视图
    private func addSub() {
        view.addSubview(headIcon)
        view.addSubview(statusLabel)
        view.addSubview(gesturePreview)
        view.addSubview(gestureView)
        view.addSubview(otherAcountBtn)
        view.addSubview(resetPassswordBtn)
        view.addSubview(forgetPasswordBtn)
    }
    
    /// 处理不同的解锁状态
    private func handleDifferentUnlockState() {
        resetPassswordBtn.isHidden = true
        switch unlockType {
        case .createPassword:
            gesturePreview.isHidden = false
            otherAcountBtn.isHidden = forgetPasswordBtn.isHidden
        case .validatePassword:
            gesturePreview.isHidden = true
            otherAcountBtn.isHidden = forgetPasswordBtn.isHidden
        }
    }
    
    /// 创建手势密码
    ///
    /// - Parameter gesturesPassword: 密码字符串
    private func createGesturesPassword(_ gesturesPassword: String) {
        // 如果密码字符串长度不等于0,执行{}后面的代码
        guard (lastGesturePassword as NSString).length != 0 else {
            
            if gesturesPassword.count < 4 {
                statusLabel.text = "至少连接四个点，请重新输入"
                shakeAnimation(for: statusLabel)
                return
            }
            if resetPassswordBtn.isHidden == true {
                resetPassswordBtn.isHidden = false
            }
            lastGesturePassword = gesturesPassword
            gesturePreview.setGesturePassword(gesturesPassword as NSString)
            statusLabel.text = "请再次绘制手势密码"
            return
        }
        
        if lastGesturePassword == gesturesPassword {
            // 消失弹出控制器, 同时添加手势密码(保存手势密码)
            dismiss(animated: true, completion: {
                GesturePasswordViewController.addGesturesPassword(gesturesPassword)
            })
        }else {
            statusLabel.text = "与上一次绘制不一致，请重新绘制"
            shakeAnimation(for: statusLabel)
        }
    }
    
    /// 验证手势密码
    ///
    /// - Parameter gesturesPassword: 密码字符串
    private func validateGesturesPassword(_ gesturesPassword: String) {

        // 如果验证通过, 执行{}后面的代码
        guard gesturesPassword == GesturePasswordViewController.gesturesPassword() else {
            // 如果已经输错五次,弹出警告框
            if errorCount - 1 == 0 {
                let alert = UIAlertController(title: "", message: "忘记手势密码, 需要重新登陆", preferredStyle: .alert)
                let other = UIAlertAction(title: "重新登陆", style: .default, handler: nil)
                alert.addAction(other)
                self.present(alert, animated: true, completion: nil)
                errorCount = 5 //恢复错误次数
                return
            }
            errorCount -= 1
            statusLabel.text = "密码错误，还可以再输入\(errorCount)次"
            shakeAnimation(for: statusLabel)
            return
        }
        dismiss(animated: true, completion: {
            errorCount = 5
        })
    }
    
    /// 抖动动画
    ///
    /// - Parameter view: UIView
    private func shakeAnimation(for view: UIView) {
        let viewLayer = view.layer
        let position = viewLayer.position   // 左右抖动
        let left = CGPoint(x: position.x - 10, y: position.y)
        let right = CGPoint(x: position.x + 10, y: position.y)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fromValue = NSValue(cgPoint: left)
        animation.toValue = NSValue(cgPoint: right)
        animation.autoreverses = true
        // 平滑结束
        animation.duration = 0.08
        animation.repeatCount = 3
        viewLayer.add(animation, forKey: nil)
    }
    
}


// MARK: - 事件监听
extension GesturePasswordViewController {

    /// 其他账户按钮点击事件
    @objc fileprivate func otherAccountLogin() {

        print("其他账户---\(#function)")
    }

    /// 重新绘制按钮点击事件
    @objc fileprivate func resetGesturePassword() {

        print("重新绘制---\(#function)")

        lastGesturePassword = ""
        statusLabel.text = "请绘制手势密码"
        resetPassswordBtn.isHidden = true
        gesturePreview.setGesturePassword("")
    }

    /// 忘记密码按钮点击事件
    @objc fileprivate func forgetGesturesPassword() {
        print("忘记密码---\(#function)")
    }

}

// MARK: - 类方法
extension GesturePasswordViewController {
    
    /// 删除手势
    class func deleteGesturesPassword() {
        UserDefaults.standard.removeObject(forKey: GesturesPassword)
        UserDefaults.standard.synchronize()
    }
    
    /// 添加手势密码
    class func addGesturesPassword(_ gesturesPassword: String?) {
        UserDefaults.standard.set(gesturesPassword, forKey: GesturesPassword)
        UserDefaults.standard.synchronize()
    }
    /// 获取密码字符串
    class func gesturesPassword() -> String {
        return UserDefaults.standard.object(forKey: GesturesPassword) as? String ?? ""
    }
}

// MARK: - LCGesturePasswordViewDelegate
extension GesturePasswordViewController: LCGesturePasswordViewDelegate {

    func gesturePasswordView(_ passView: GesturePasswordView?, drawRectFinished gesturePassword: String?) {

        switch unlockType {
        case .createPassword:
            createGesturesPassword(gesturePassword!)
        case .validatePassword:
            validateGesturesPassword(gesturePassword!)
        }
    }
    
}



