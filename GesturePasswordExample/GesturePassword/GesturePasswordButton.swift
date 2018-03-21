//
//  GesturePasswordButton.swift
//  GesturePasswordExample
//
//  Created by Liu Chuan on 2018/3/26.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit

//按钮线宽
private let buttonCircleW : CGFloat = 0
//按钮stroker圆宽
private let buttonWidth : CGFloat = 50

//按钮内圆宽
private let smallButtonW : CGFloat = 20
//内圆originXY
private let smallButtonXY : CGFloat = 20


/// 手势密码按钮
class GesturePasswordButton: UIButton {

    // 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = frame.width * 0.5
        layer.masksToBounds = true
    }

    /** 绘制界面 **/
    /*
     调用情况:
        1.UIView初始化后自动调用
        2.调用setNeedsDisplay方法时会自动调用）
     */
    override func draw( _ rect: CGRect) {
        
        // 开启图形上下文
        let context = UIGraphicsGetCurrentContext()!
        // 线宽
        context.setLineWidth(buttonCircleW)
        
        if isSelected == true {
            layer.borderColor = UIColor.blue.cgColor
            bigCircle(context)
            samllCircle(context)
        }else {
            layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    /// 绘制大圆
    ///
    /// - Parameter context: 图形上下文
    private func bigCircle(_ context: CGContext) {
        
        /// 尺寸位置
        let frame : CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height)
        // 根据尺寸位置画圆
        context.addEllipse(in: frame)
        // 描边颜色
        context.setStrokeColor(UIColor.clear.cgColor)
        // 描边渲染
        context.strokePath()
        // 填充颜色
        context.setFillColor(UIColor.white.cgColor)
        context.addEllipse(in: frame)
        // 填充渲染
        context.fillPath()
    }
    
    /// 绘制小圆
    ///
    /// - Parameter context: 图形上下文
    private func samllCircle(_ context: CGContext) {
        
        /// 尺寸位置
        let frame : CGRect = CGRect(x: (self.frame.size.width - smallButtonW) / 2, y: (self.frame.size.height - smallButtonW) / 2, width: smallButtonW, height: smallButtonW)
        
        // 根据尺寸位置画圆
        context.addEllipse(in: frame)
        
        // 描边颜色
        context.setStrokeColor(UIColor.clear.cgColor)
        
        // 描边渲染
        context.strokePath()
        
        // 填充颜色
        context.setFillColor(UIColor.blue.cgColor)
        
        // 根据矩形画圆（椭圆只是设置不同的长宽
        context.addEllipse(in: frame)
        
        // 填充渲染
        context.fillPath()
    }
    
    /// 颜色转换成图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 图片
    private func imageWithColor(color: UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }

    /// 设置按钮不同状态的背景色
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - state: 状态
    func LCsetBackgroundColor(color: UIColor, forUIControlState state: UIControlState) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
