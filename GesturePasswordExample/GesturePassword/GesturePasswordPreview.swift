//
//  GesturePasswordPreview.swift
//  GesturePasswordExample
//
//  Created by Liu Chuan on 2018/3/25.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit


/// 手势密码预览视图
class GesturePasswordPreview: UIView {
    
    
    /// 按钮数组
    var buttons = [UIButton]()
    
    /// 横\纵 的个数
    let cols = 3
    
    /// 按钮的个数
    let buttonsCount = 9
    
    /// 按钮的X值
    var btnX: CGFloat = 0
    
    /// 按钮的Y值
    var btnY: CGFloat = 0
    
    /// 按钮的宽度
    let btnW: CGFloat = 9
    
    /// 按钮的高度
    let btnH: CGFloat = 9
    
    // MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*** 布局视图的时候调用 ***/
    /*
     为什么要在这个方法中布局子控件.
     因为只调用这个方法, 就表示父控件的尺寸确定
     */
    open override func layoutSubviews() {
        super.layoutSubviews()
 
        createButtonView()
    }

    /// 创建按钮: 九宫格 (9个按钮)
    private func createButtonView() {
       
        /// 列
        var col = 0
        /// 行
        var row = 0
        
        /// 水平间距: (当前视图的宽度 - 3列按钮的宽度) / 4个间距
        let horizontalMargin: CGFloat = (bounds.size.width - CGFloat(cols) * btnW) / CGFloat(cols + 1)
        
        /// 垂直间距: (当前视图的高度 - 3行按钮的高度) / 4个间距
        let verticalMargin: CGFloat = (bounds.size.height - CGFloat(cols) * btnH) / CGFloat(cols + 1)
        
        /** 布局9个按钮 **/
        for i in 0 ..< buttonsCount {
            // 计算当前所在行\列
            col = i % cols
            row = i / cols
            // 计算按钮的最终坐标
            btnX = horizontalMargin + (btnW + horizontalMargin) * CGFloat(col)
            btnY = verticalMargin + (btnH + verticalMargin) * CGFloat(row)
            
            /**  GesturePasswordButton  **/
            let btn = GesturePasswordButton(frame: CGRect(x: btnX, y: btnY, width: btnW, height: btnH))
            btn.isUserInteractionEnabled = false
            btn.LCsetBackgroundColor(color: UIColor.white, forUIControlState: .normal)
            btn.LCsetBackgroundColor(color: UIColor.blue, forUIControlState: .selected)
           
            addSubview(btn)
            buttons.append(btn)
        }
    }

    
    /// 设置手势密码
    ///
    /// - Parameter gesturePassword: 手势密码字符串
    func setGesturePassword(_ gesturePassword: NSString) {
        
        // 如果字符串长度 == 0 , 设置按钮不选中, 且直接返回
        guard gesturePassword.length != 0 else {
            for btn: UIButton in buttons {
                btn.isSelected = false
            }
            return
        }
        
        for i in 0 ..< gesturePassword.length {
            
            print(gesturePassword.length)
            
            let s = gesturePassword.substring(with: NSRange(location: i, length: 1)) as NSString
            buttons[s.integerValue].isSelected = true
        }
    }
  
}
