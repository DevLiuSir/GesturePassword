//
//  LCUnlockType.swift
//  GesturePasswordExample
//
//  Created by Liu Chuan on 2019/12/8.
//  Copyright © 2019 LC. All rights reserved.
//

import Foundation


/// 解锁类型
///
/// - createPassword: 创建手势密码
/// - validatePassword: 验证手势密码
public enum LCUnlockType {
    /// 创建手势密码
    case createPassword
    /// 验证手势密码
    case validatePassword
}
