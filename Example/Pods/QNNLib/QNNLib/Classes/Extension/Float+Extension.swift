//
//  Float+Extension.swift
//  QNN
//
//  Created by joewang on 2018/12/14.
//  Copyright © 2018 qianshengqian. All rights reserved.
//

import Foundation

public extension Float {
    
    /// 绝对值
    func qnn_abs () -> Float {
        return fabsf(self)
    }
    
    /// 开方
    func qnn_sqrt () -> Float {
        return sqrtf(self)
    }
    
    /// 向下取整
    func qnn_floor () -> Float {
        return floorf(self)
    }
    
    /// 向上取整
    func qnn_ceil () -> Float {
        return ceilf(self)
    }
    
    /// 四舍五入
    func qnn_round () -> Float {
        return roundf(self)
    }
    
    /// 不超过最大值和最小值
    func qnn_clamp (min: Float, _ max: Float) -> Float {
        return Swift.max(min, Swift.min(max, self))
    }
    
    /// 最大值和最小值之间的随机值
    static func qnn_random(min: Float = 0, max: Float) -> Float {
        let diff = max - min;
        let rand = Float(arc4random() % (UInt32(RAND_MAX) + 1))
        return ((rand / Float(RAND_MAX)) * diff) + min;
    }
    
}

public extension CGFloat {
    
    /// 向下取整
    func qnn_floor () -> CGFloat {
        return CGFloat(Float(self).qnn_floor())
    }
    
    /// 向上取整
    func qnn_ceil () -> CGFloat {
        return CGFloat(Float(self).qnn_ceil())
    }
    
    /// 四舍五入
    func qnn_round () -> CGFloat {
        return CGFloat(Float(self).qnn_round())
    }
}
