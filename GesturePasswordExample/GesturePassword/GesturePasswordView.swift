//
//  GesturePasswordView.swift
//  GesturePasswordExample
//
//  Created by Liu Chuan on 2018/3/25.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit

let screenW: CGFloat = UIScreen.main.bounds.width
let screenH: CGFloat = UIScreen.main.bounds.height


/// 手势密码视图
class GesturePasswordView: UIView {

    // MARK: - 属性 ( attribute )
    
    /// 代理
    weak var delegate: LCGesturePasswordViewDelegate?
    
    /// 选择按钮数组
    var selectBtns = [UIButton]()
    
    /// 当前起点
    var currentPoint = CGPoint.zero
    
    /// 横\纵 的个数
    let cols = 3
    
    /// 按钮的个数
    let buttonsCount = 9
    
    /// 按钮的X值
    var btnX: CGFloat = 0
    
    /// 按钮的Y值
    var btnY: CGFloat = 0
    
    /// 按钮的宽度
    let btnW: CGFloat = 50
    
    /// 按钮的高度
    let btnH: CGFloat = 50
    
    // MARK: - 系统方法 ( system method )
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        
        /// 拖动手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        addGestureRecognizer(pan)
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
    
    
    /** 绘制界面 **/
    /*
     调用情况:
            1.UIView初始化后自动调用
            2.调用setNeedsDisplay方法时会自动调用）
     */
    override func draw(_ rect: CGRect) {
    
        //如果没有选中按钮的时候,直接返回
        if selectBtns.count == 0 { return }

        // 创建一个贝塞尔路径: 把所有选中按钮中心点连线
        let path = UIBezierPath()
        if isUserInteractionEnabled { // 如果按钮开启交互设置颜色
            UIColor.blue.set()
        }else {
            UIColor.orange.set()
        }
        for i in 0..<selectBtns.count {
            /// 取出按钮
            let button = selectBtns[i]
            if i == 0 {
                // 设置起点
                path.move(to: button.center)
            }else {
                path.addLine(to: button.center)
            }
        }
        path.addLine(to: currentPoint)
        // 设置路径属性
        path.lineWidth = 5
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.stroke()   // 渲染
    }

}

// MARK: - 自定义的方法 ( custom method )
extension GesturePasswordView {

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
//            btn.LCsetBackgroundColor(color: UIColor.white, forUIControlState: .selected)
            btn.isUserInteractionEnabled = false
            btn.backgroundColor = .clear
            addSubview(btn)
            btn.tag = i + 1
        }
    }
}


// MARK: - 事件监听
extension GesturePasswordView {
    
    /// 拖动手势监听
    ///
    /// - Parameter pan: 拖动手势
    @objc private func panGesture(_ pan: UIPanGestureRecognizer) {
        
        // 给当前点赋值
        currentPoint = pan.location(in: self)
        
        setNeedsDisplay()
        
        // 遍历当前所有子视图
        for button in subviews {
            let btn = button as! UIButton
            if btn.frame.contains(currentPoint) && btn.isSelected == false {
                btn.isSelected = true
                selectBtns.append(btn)
            }
        }
        
        layoutIfNeeded()
        
        /// 手势结束的时候
        if pan.state == .ended {
            
            // 保存输入密码
            // 注意：我们在密码判定过程中是通过根据先前布局按钮的时候定义的按钮tag值进行字符串拼接，密码传值是通过代理实现。
            
            var gesturePwd = ""
            
            for btn in self.selectBtns {
                gesturePwd += "\(btn.tag - 1)"
                btn.isSelected = false
            }
            selectBtns.removeAll()
            
            //手势密码绘制完成后的回调
            if self.delegate != nil {
                delegate?.gesturePasswordView(self, drawRectFinished: gesturePwd)
            }
        }
    }
}


// MARK: - 手势代理协议
@objc
protocol LCGesturePasswordViewDelegate: NSObjectProtocol {
    
    
    /// 显示九宫格
    ///
    /// - Parameters:
    ///   - passView: 手势密码视图
    ///   - gesturePassword: 密码
    func gesturePasswordView(_ passView: GesturePasswordView?, drawRectFinished gesturePassword: String?)
    
    
}
