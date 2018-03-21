//
//  ViewController.swift
//  GesturePasswordExample
//
//  Created by Liu Chuan on 2018/3/25.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    /// 创建手势
    ///
    /// - Parameter sender: UIButton
    @IBAction func createBtnClicked(_ sender: UIButton) {
        print("创建手势密码---\(#function)")
        let vc = GesturePasswordViewController(unlockType: .createPassword)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    /// 验证手势
    ///
    /// - Parameter sender: UIButton
    @IBAction func validationBtnClicked(_ sender: UIButton) {
        
        print("效验手势密码---\(#function)")
        
        if GesturePasswordViewController.gesturesPassword().count > 0 {
            let vc = GesturePasswordViewController(unlockType: .validatePassword)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    /// 删除手势
    ///
    /// - Parameter sender: UIButton
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        print("删除手势密码---\(#function)")
        GesturePasswordViewController.deleteGesturesPassword()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}




